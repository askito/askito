class QuestionsController < ContentsController
  
  def self.controller_path
    ContentsController.controller_path
  end
  
protected
  
  def new_content(attributes = {})
    Question.new(attributes)
  end
  
  def find_content_type
    QUESTIONNAIRE_CONTENT_TYPES['questions'].detect{|t| t['name'] == "#{params[:content_type]}"}['name']
  end
  
  def content_params
    params[:question]
  end
  
end