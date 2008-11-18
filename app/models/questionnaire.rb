class Questionnaire < ActiveRecord::Base
  # include Page
  
  attr_accessor :current_page
  
  # this is necessary when
  # a quesitonnaire is duplicated
  # or saved as template
  before_create :reset_respondents_count
  
  validates_presence_of :title, :user_id
  
  belongs_to  :user
  belongs_to  :questionnaire_template
  has_many    :contents, :class_name => 'Content', :dependent => :destroy, :order => 'contents.position'
  has_many    :questions, :order => 'contents.position'
  # has_many    :users, :through => :respondents, :order => 'users.login'
  # has_many    :exports, :order => 'exports.created_at desc', :dependent => :destroy
  
  def duplicate
    rejected_attributes = %w[id type created_at updated_at respondents_count]
    questionnaire = self.class.name.constantize.new(self.attributes.reject{|key,value| rejected_attributes.include?(key)})
    questionnaire.save
    contents.each do |content|
      copy = content.copy
      questionnaire.contents << copy
      
      
      # copy.clone_assets(content)
      
    end
    questionnaire
  end
  
  
  def pages
    @pages ||= calculate_pages
  end
  
  def previous_page
    if @current_page
      pages.reverse.find{|p| p[:id] < @current_page[:id]}
    else
      nil
    end
  end
  
  def previous_page?
    !previous_page.nil?
  end
  
  def next_page
    if @current_page
      pages.find{|p| p[:id] > @current_page[:id]}
    else
      nil
    end
  end
  
  def next_page?
    !next_page.nil?
  end
  
  def last_page
    pages.any? ? pages.last : nil
  end
  
  def last_page?(page = nil)
    if @current_page
      @current_page[:id] == last_page[:id]
    elsif pages.any?
      false
    else
      true
    end
  end
  
  def find_page(id = nil)
    if pages.any?
      if id
        pages.find{|p| p[:id].to_i == id.to_i}
      else
        pages.sort_by{|p| p[:id]}.first
      end
    else
      nil
    end
  end
  
  def find_page_by_position(position)
    pages.find{|p| (p[:from]..p[:to]).include?(position)}
  end
  
  def current_page=(page)
    @current_page = find_page(page)
  end
  
  
  def find_contents_for_current_page
    if current_page
      contents.between_positions(current_page[:from], current_page[:to])
    else
      contents
    end
  end
  
protected
  
  def calculate_pages
    pages = []
    pagebreaks = contents.pagebreaks
    if pagebreaks
      pagebreaks.each_with_index do |pb, i|
        from = @to || 0
        @to = pb.position
        page = {:id => i + 1}
        page.merge!(:from => from)
        page.merge!(:to => @to)
        pages << page
      end
      pages << { :id => pagebreaks.length + 1, :from => @to, :to => 1e6}
    end
    pages
  end
  
  def reset_respondents_count
    respondents_count = 0
  end
  
end
