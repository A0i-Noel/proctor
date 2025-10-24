class ResponsesController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def index
    @survey = Survey.find(params[:survey_id])
    @responses = @survey.responses.includes(:role, :question).order(:id)

    respond_to do |format|
      format.html 
      format.json do
        render json: @responses.map { |r|
          {
            id: r.id,
            survey_id: r.survey_id,
            question_id: r.question_id,
            role_id: r.role_id,
            value: r.value,
            created_at: r.created_at
          }
        }
      end
    end
  end

  def create
    survey = Survey.find(params[:survey_id])

    payload = extract_payload 

    role_id = payload[:respondent_role_id].presence&.to_i
    items   = payload[:question_responses_attributes] || []

    created = []
    Response.transaction do
      items.each do |h|
        created << survey.responses.create!(
          question_id: h[:question_id],
          value:       h[:content],
          role_id:     role_id
        )
      end
    end

    render json: { success: true, count: created.size }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
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
