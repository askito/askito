class Content < ActiveRecord::Base

  belongs_to  :questionnaire

  has_many    :options, :foreign_key => 'question_id', :order => 'options.position', :dependent => :destroy
  has_many    :answers, :foreign_key => 'question_id'
  has_many    :answer_texts, :foreign_key => 'question_id'
  has_many    :answer_dates, :foreign_key => 'question_id'

  acts_as_list :order => 'contents.position'
  # acts_as_textiled :text
  serialize :settings

  named_scope :pagebreaks, lambda{{
    :conditions => "template = 'pagebreak'",
    :order => 'contents.position'
  }}

  named_scope :between_positions, lambda{|i,j|{
    :conditions => ["contents.position BETWEEN ? AND ?", i + 1, j - 1]
  }}

  def copy
    Content.new(self.attributes.reject{|key,value| exclude_attributes_from_duplication.include?(key)})
  end

  def exclude_attributes_from_duplication
    %w[id type created_at updated_at code questionnaire_id]
  end
  
end
