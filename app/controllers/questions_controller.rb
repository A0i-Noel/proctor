class QuestionsController < ApplicationController
  before_action :set_survey
  before_action :set_question, only: [:edit, :update, :destroy]


  def new
    @question = @survey.questions.new
  end

  def create
    @question = @survey.questions.new(question_params.except(:target_role_ids))
    process_options(@question)

    ActiveRecord::Base.transaction do
      @question.save!
      sync_targets(@question)
    end

    redirect_to survey_path(@survey), notice: "Question was successfully created."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      @question.assign_attributes(question_params.except(:target_role_ids))
      process_options(@question)

      @question.save!
      sync_targets(@question)                     # ← replaces join rows to match form
    end

    redirect_to survey_path(@survey), notice: "Question was successfully updated."
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @question.destroy
    redirect_to survey_path(@survey), notice: 'Question was successfully destroyed.'
  end
  
  private
  
  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
  
  def set_question
    @question = @survey.questions.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:content, :question_type, :position, :required, options: [],target_role_ids: [] )
  end
  
  def process_options(q)
    if params.dig(:question, :options).present? && %w[multiple_choice checkbox].include?(q.question_type)
      q.options = params[:question][:options].to_s.split("\n").map(&:strip).reject(&:blank?)
    else
      q.options = []
    end
  end
  
  def sync_targets(q)
    raw_ids = Array(params.dig(:question, :target_role_ids))
    ids = raw_ids.map { |v| Integer(v) rescue nil }.compact.uniq
    q.target_roles = Role.where(id: ids)          # ActiveRecord updates question_role_targets
  end
end
