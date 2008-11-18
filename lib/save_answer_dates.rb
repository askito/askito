module SaveAnswerDates
  
  def new_answer_date_attributes=(answer_date_attributes)
    answer_dates_on_current_page.reject{|at| !at.new_record?}.each do |answer_date|
      value = answer_date_attributes[answer_date.question.id.to_s]
      assign_answer_date(answer_date, value)
    end
  end
  
  def existing_answer_date_attributes=(answer_date_attributes)
    answer_dates_on_current_page.reject(&:new_record?).each do |answer_date|
      value = answer_date_attributes[answer_date.id.to_s]
      assign_answer_date(answer_date, value)
    end
  end
  
protected
  
  def assign_answer_date(answer_date, value)
    answer_date.value = value
    if value.blank? && answer_date.valid?
      answer_dates.delete(answer_date)
      answer_dates_on_current_page.delete(answer_date)
    end
  end
  
  def save_answer_dates
    answer_dates_on_current_page.each(&:save)
  end
  
  
  
end