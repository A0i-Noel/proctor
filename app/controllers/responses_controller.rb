class ResponsesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def index
    @survey = Survey.find(params[:survey_id])
    @roles  = Role.order(:role)
    @current_role_id = params[:role_id].presence

    base = @survey.submissions
                  .includes(:role, responses: :question)
                  .order(created_at: :desc)

    @submissions = @current_role_id ? base.where(role_id: @current_role_id) : base

    # keep your header totals (submissions per role)
    @submissions_by_role = @survey.submissions.group(:role_id).count
  end

  def create
    survey  = Survey.find(params[:survey_id])
    payload = extract_payload

    role_id = payload[:respondent_role_id].presence&.to_i
    items   = Array(payload[:question_responses_attributes])

    created = []

    Submission.transaction do
      submission = survey.submissions.create!(role_id: role_id)

      items.each do |h|
        qid = h[:question_id].to_i
        val = h[:content]

        # (optional) ensure question belongs to this survey:
        # raise ActiveRecord::RecordNotFound unless survey.questions.exists?(qid)

        created << survey.responses.create!(
          question_id: qid,
          value:       val,     # strings or arrays are fine (text column)
          role_id:     role_id,
          submission:  submission
        )
      end
    end

    render json: { success: true, count: created.size }, status: :created

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActionController::ParameterMissing, JSON::ParserError => e
    render json: { error: "Invalid payload: #{e.message}" }, status: :bad_request
  end


  private

  # Accepts proper JSON (params[:response]) OR fallback where JSON was sent as a string in params[:body] or raw body
  def extract_payload
    if params[:response].present?
      return params.require(:response).permit(
        :survey_id, :respondent_role_id,
        question_responses_attributes: [:question_id, :content]
      )
    end

    raw = params[:body].presence || request.body.read
    raise ActionController::ParameterMissing, "response" if raw.blank?

    json = JSON.parse(raw)
    ActionController::Parameters.new(json.fetch("response")).permit(
      :survey_id, :respondent_role_id,
      question_responses_attributes: [:question_id, :content]
    )
  end
end
