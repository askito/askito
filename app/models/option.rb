class Option < ActiveRecord::Base
  
  belongs_to  :question
  has_many    :answers, :dependent => :destroy
  
  validates_presence_of :value
  validates_uniqueness_of :value, :scope => [:question_id, :option_type], :allow_nil => true
  
  named_scope :option_choices, :conditions => "options.option_type is null"
  named_scope :option_rows, :conditions => "options.option_type = 'row'"
  named_scope :option_columns, :conditions => "options.option_type = 'col'"
  
end
