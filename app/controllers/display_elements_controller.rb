class DisplayElementsController < ContentsController
  
  def self.controller_path
    ContentsController.controller_path
  end
  
protected
  
  def new_content(attributes = {})
    DisplayElement.new(attributes)
  end
  
  def find_content_type
    QUESTIONNAIRE_CONTENT_TYPES['display_elements'].detect{|t| t['name'] == "#{params[:content_type]}"}['name']
  end
  
  def content_params
    params[:display_element]
  end
  
end