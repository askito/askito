class Answer < ActiveRecord::Base
  
  belongs_to :question, :counter_cache => true
  belongs_to :option, :counter_cache => true
  belongs_to :respondent
  
  
  named_scope :find_by_contents, 
    lambda{|ids|{
      :conditions => ["answers.question_id in (?)", ids]
    }}
  
  def validate
    unless question.template == 'multiple_choice'
      errors.add_to_base("Answer is required") if required? && option_id.blank?
    else
      errors.add_to_base("Answer is required") if required?
    end
    
  end
  
  
  def required?
    !question.nil? && question.requires_answer?
  end
  
  
end
