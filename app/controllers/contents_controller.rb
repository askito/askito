class ContentsController < ApplicationController
  
  before_filter :find_questionnaire
  before_filter :find_content, :only => [:edit, :update, :destroy]
  # skip_before_filter :verify_authenticity_token, :only => [:sort]
  
  def new
    if template = find_content_type
      @content = new_content(:questionnaire => @questionnaire, :template => template)
      @content.assets.build if template == 'image'
      @successful = true
    end
  end
  
  def edit
  end
  
  def create
    # if template = find_content_type
    #   @content = new_content(:questionnaire => @questionnaire, :template => template)
    #   save
    # end
    # render :text => params.inspect
    @content = new_content(:questionnaire => @questionnaire)
    save
  end
  
  def update
    save
    # render :text => params.inspect
  end
  
  def destroy
    @content.destroy
    respond_to do |wants|
      wants.html  { redirect_to @questionnaire }
      wants.js
    end
  end
  
  def sort
    if request.xhr?
      params[:contents].each_with_index do |id, position|
        Content.update(id, :position => position + 1)
      end
      render :nothing => true
    end
  end
  
protected
  
  def find_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  end
  
  def find_content
    @content = @questionnaire.contents.find(params[:id])
    instance_variable_set("@#{@content.class.name.underscore}", @content)
  end
  
  def save
    @content.attributes = content_params
    @content.save!
    respond_to do |wants|
      wants.html  { redirect_to @questionnaire }
      wants.js    { @successful = true }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |wants|
      wants.html  { render_invalid_record(@content) }
      wants.js    { @successful = false }
    end
  end
  
  
  
  
end
