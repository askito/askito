class AnswerText < ActiveRecord::Base
  
  belongs_to :respondent
  belongs_to :question
  
  validates_presence_of :value, 
                        :message => "is required", 
                        :if => proc { |answer_text| answer_text.required? }
  
  
  named_scope :find_by_contents, 
    lambda{|ids|{
      :conditions => ["answer_texts.question_id in (?)", ids]
    }}
  
  
  def data_type
    question.content_type.data_type
  end
  
  def calculate_value
    case data_type
    when 'date'
      self.value = convert_date(self.value)
      self.value = self.value.to_s(:db) if self.value
      return self.value
    end
  end
  
  def required?
    !question.nil? && question.requires_answer?
  end
  
end
