module SaveAnswerTexts
  
  def new_answer_text_attributes=(answer_text_attributes)
    answer_texts_on_current_page.reject{|at| !at.new_record?}.each do |answer_text|
      value = answer_text_attributes[answer_text.question.id.to_s]
      assign_answer_text(answer_text, value)
    end
  end
  
  def existing_answer_text_attributes=(answer_text_attributes)
    answer_texts_on_current_page.reject(&:new_record?).each do |answer_text|
      value = answer_text_attributes[answer_text.id.to_s]
      assign_answer_text(answer_text, value)
    end
  end
  
protected
  
  def assign_answer_text(answer_text, value)
    answer_text.value = value
    if value.blank? && answer_text.valid?
      answer_texts.delete(answer_text)
      answer_texts_on_current_page.delete(answer_text)
    end
  end
  
  def save_answer_texts
    answer_texts_on_current_page.each(&:save)
  end
  
  
  
end