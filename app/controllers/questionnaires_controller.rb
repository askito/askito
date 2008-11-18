class QuestionnairesController < ApplicationController
  
  before_filter :find_questionnaire, :only => [:edit, :update, :destroy, :duplicate]
  after_filter :set_flash_message, :only => [:create, :update, :destroy]
  
  def index
    @questionnaires = current_user.questionnaires
  end
  
  def show
    @questionnaire = Questionnaire.find(params[:id], :include => [:contents => [:options]])
  end
  
  def new
    @questionnaire = Questionnaire.new
    find_templates
  end
  
  def edit
  end
  
  def create
    @questionnaire = Questionnaire.new(params[:questionnaire].merge(:user => current_user))
    @questionnaire.save!
    unless params[:questionnaire][:template_id].blank?
      if @template = QuestionnaireTemplate.find(params[:questionnaire][:template_id])
        @questionnaire.duplicate_contents(@template)
      end
    end
    redirect_to @questionnaire
  rescue ActiveRecord::RecordInvalid
    find_templates
    render_invalid_record(@questionnaire)
  end
  
  def update
    @questionnaire.attributes = params[:questionnaire]
    redirect_to @questionnaire
  end
  
  def destroy
    @questionnaire.destroy
    redirect_to questionnaires_url
  end
  
  def duplicate
    @copy = @questionnaire.duplicate
    flash[:notice] = "#{@copy.class.name} was successfully duplicated."
    redirect_to @copy
  end
  
protected
  
  def find_questionnaire
    @questionnaire ||= current_user.questionnaires.find(params[:id])
  end
  
  def find_templates
    @templates = QuestionnaireTemplate.all :order => :title
  end
  
  def set_flash_message
    default_flash_message(@questionnaire)
  end
  
end
