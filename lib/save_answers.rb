module SaveAnswers
  
  def new_answer_attributes=(answer_attributes)
    answers_on_current_page.reject{|at| !at.new_record?}.each do |answer|
      value = answer_attributes.blank? ? nil : answer_attributes[answer.question.id.to_s]
      assign_answer(answer, value)
    end
  end
  
  def existing_answer_attributes=(answer_attributes)
    answers_on_current_page.reject(&:new_record?).each do |answer|
      value = answer_attributes.blank? ? nil : answer_attributes[answer.id.to_s]
      assign_answer(answer, value)
    end
  end
  
  def assign_answer(answer, value = nil)
    case answer.question.template
    when 'rating_scale', 'semantic_differential'
      assign_rating_scale(answer, value)
    when 'multiple_choice'
      assign_multiple_choice(answer, value)
    else
      assign_single_choice(answer, value)
    end
  end
  
protected
  
  def save_answers
    answers_on_current_page.each(&:save)
  end
  
  def assign_single_choice(answer, value = nil)
    unless value.blank?
      answer.option_id = value
    else
      unless answer.required?
        answers_on_current_page.delete(answer)
        answers.delete(answer)
      end
    end
  end
  
  def assign_multiple_choice(answer, value = nil)
    unless value.blank?
      unless value.include?(answer.option_id.to_s)
        answers.delete(answer)
        answers_on_current_page.delete(answer)
      end
    else
      if answer.required?
        remaining_options = self.answers_on_current_page.reject{|a| a.question_id != answer.question_id}
        count = remaining_options.nil? ? 0 : remaining_options.length
        if count > 1
          answers.delete(answer)
          answers_on_current_page.delete(answer)
        end
      else
        answers.delete(answer)
        answers_on_current_page.delete(answer)
      end
    end
  end
  
  def assign_rating_scale(answer, value = nil)
    unless value.blank?
      if value.detect{|k,v| k == answer[:row_id].to_s}
        answer.col_id = value[answer[:row_id].to_s]
      end
    else
      unless answer.required?
        answers_on_current_page.delete(answer)
        answers.delete(answer)
      end
    end
  end
  
  
  
end