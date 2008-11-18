class AnswerDate < ActiveRecord::Base
  
  belongs_to :respondent
  belongs_to :question
  
  named_scope :find_by_contents, 
    lambda{|ids|{
      :conditions => ["answer_dates.question_id in (?)", ids]
    }}
  
end
