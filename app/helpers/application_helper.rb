# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def navigation
    if logged_in?
      @navigation ||= calculate_navigation
    end
  end
  
  def calculate_navigation
    navArray = []
    NAVIGATION.sort.each do |item|
      navArray << navigation_item(item[1])
    end
    navArray.join("\n")
  end
  
  def navigation_item(item)
    link = link_to(item['title'], "/#{item['resource']}")
    # style = controller.controller_name == item['resource'] ? 'current' : nil
    style = item['controllers'].split(',').each{|i| i.strip!}.include?(controller.controller_name) ? 'current' : nil
    content_tag("li", link, :class => style)
  end
  
  def print_excerpt(text, str = '', radius = 300)
    excerpt(text, str, radius)
  end
  
  def print_flash
    if !flash[:error].blank?
      content_tag("div", flash[:error], :class => "flash-error notice")
    elsif !flash[:notice].blank?
      content_tag("div", flash[:notice], :class => "flash-notice notice")
    end
  end
  
  def reset_flash_with_delay(delay = 15000)
    javascript_tag("
      setTimeout(function(){ Element.update('flashes',''); }, #{delay});
    ")
  end
  
  def toggle_box_body_link
    l = link_to_function "(show/hide)", "this.up(1).next().toggle()"
    content_tag("small", l)
  end
  
  def icon(purpose, label = nil)
    case purpose
    when :new
      i = 'add'
    when :delete
      i = 'cross'
    when :edit
      i = 'pencil'
    when :copy
      i = 'copy'
    when :sort
      i = 'arrow_switch'
    when :save
      i = 'tick'
    when :chat
      i = 'chat_small'
    end
    image_tag("icons/#{i}.png", :title => label.blank? ? purpose : label)
  end
  
  def show_tab(tab)
    "this.up('.tabs').siblings('.tab-content').each(function(el){el.hide();});" + 
    "this.up('.tabs').childElements('.tab').each(function(el){el.removeClassName('current')});" + 
    "this.up().addClassName('current');" + 
    "$('#{tab}').show();"
  end
  
end
