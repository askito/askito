module ContentsHelper
  
  def new_content_link(controller, content_type)
    url_params = {:controller => controller, :questionnaire_id => @questionnaire.id}
    title = content_type['title'] || content_type['name']
    unless content_type['name'] == 'pagebreak'
      url_params.merge!(:action => 'new', :content_type => content_type['name'])
      method = :get
    else
      url_params.merge!(:action => 'create', controller.singularize => {:template => content_type['name']})
      method = :post
    end
    link_to_remote(title.humanize, :url => url_for(url_params), :method => method, :html => {:title => "New #{content_type['name'].humanize.downcase}"})
  end
  
  def content_form_id
    if @content.new_record?
      'new_content_form'
    else
      "edit_#{dom_id(@content)}_form"
    end
  end
  
  def url_for_content_form
    c = @content.class.name.underscore.pluralize
    if @content.new_record?
      # questionnaire_contents_path(@questionnaire)
      url_for(:controller => c, :action => 'create', :questionnaire_id => @questionnaire)
    else
      # questionnaire_content_path(@questionnaire, @content)
      url_for(:controller => c, :action => 'update', :questionnaire_id => @questionnaire, :id => @content)
    end
  end
  
  def template(content = nil)
    content ? content.template : @content.template
  end
  
  def toggle_actions_script
    javascript_tag("
      Event.addBehavior({
        '#contents .content:mouseover': function() { this.down('.actions').show(); },
        '#contents .content:mouseout': function() { this.down('.actions').hide(); }
      })
    ")
  end
  
end
