class Respondent < ActiveRecord::Base
  
  include SaveAnswers
  include SaveAnswerTexts
  include SaveAnswerDates
  
  after_update  :save_answers, 
                :save_answer_texts,
                :save_answer_dates
  
  belongs_to  :questionnaire
  has_many    :answers
  has_many    :answer_texts
  has_many    :answer_dates
  
  
  def completed?
    !completed_at.blank?
  end
  
  def active?
    !started_at.blank? && !completed?
  end
  
  def pending?
    !active? && !completed?
  end
  
  def state
    if completed?
      'completed'
    elsif active?
      'active'
    else
      'pending'
    end
  end
  
  def start!
    self.update_attribute(:started_at, Time.now)
  end
  
  def complete!
    self.update_attribute(:completed_at, Time.now)
    self.task.complete!
  end
  
  
  def self.find_for_export(questionnaire)
    find  :all,
          :conditions => ["respondents.questionnaire_id = ?", questionnaire],
          :include => [
            [:questionnaire => [:questions => [:content_type, :options]]],
            :answers,
            :answer_texts
          ]
  end
  
  def collect_answers_by_question(question)
    values = []
    case question.content_type.name
    when 'multiple_choice'
      values << get_values_for_multiple_choice(question)
    when 'rating_scale'
      values << get_values_for_rating_scale(question)
    when 'single_choice'
      values << get_value_for_single_choice(question)
    else
      unless question.content_type.category.downcase == 'profile attributes'
        values << get_value_for_answer_text(question)
      else
        values << nil
      end
    end
    values
  end
  
  
  def assign_answer_unless_exists(question)
    case question.answer_model
    when 'AnswerText'
      unless a = answer_texts.detect{ |a| a.question_id == question.id }
        a = answer_texts.build(:question => question)
      end
      answer_texts_on_current_page << a
    when 'AnswerDate'
      unless a = answer_dates.detect{ |a| a.question_id == question.id }
        a = answer_dates.build(:question => question)
      end
      answer_dates_on_current_page << a
    when 'Answer'
      case question.template
      when 'rating_scale', 'semantic_differential'
        question.options.option_rows.each do |row|
          unless a = answers.detect{|a| a.question_id == question.id && a.row_id == row.id}
            a = answers.build(:question => question, :row_id => row.id)
          end
          answers_on_current_page << a
        end
      when 'multiple_choice'
        question.options.each do |option|
          unless a = answers.detect{|a| a.option_id == option.id}
            a = answers.build(:question => question, :option => option)
          end
          answers_on_current_page << a
        end
      else
        unless a = answers.detect{ |a| a.question_id == question.id }
          a = answers.build(:question => question)
        end
        answers_on_current_page << a
      end
    end
  end
  
  def answers_on_current_page
    @answers_on_current_page ||= []
  end
  def answers_on_current_page=(answer)
    @answers_on_current_page << answer
  end
  
  def answer_texts_on_current_page
    @answer_texts_on_current_page ||= []
  end
  def answer_texts_on_current_page=(answer)
    @answer_texts_on_current_page << answer
  end
  
  def answer_dates_on_current_page
    @answer_dates_on_current_page ||= []
  end
  def answer_dates_on_current_page=(answer)
    @answer_dates_on_current_page << answer
  end
  
  def answers_valid?
    answers_on_current_page_valid? && answer_texts_on_current_page_valid? && answer_dates_on_current_page_valid?
  end
  
private
  
  def get_values_for_multiple_choice(question)
    values = []
    question.options.each do |option|
      if answer = answers.detect{|a| a.option_id == option.id}
        values << option.id
      else
        values << nil
      end
    end
    values
  end
  
  def get_values_for_rating_scale(question)
    values = []
    
    rows = question.options.reject{|o| o.option_type == 'col'}.map(&:id)
    cols = question.options.reject{|o| o.option_type == 'row'}.map(&:id)
    debugger
    rows.each do |row|
      if answer = answers.detect{|a| rows.include?(a.row_id)}
        values << answer.col_id
      else
        values << nil
      end
    end
    values
  end
  
  def get_value_for_single_choice(question)
    if answer = answers.detect{|a| a.question_id == question.id}
      answer.option_id
    else
      nil
    end
  end
  
  def get_value_for_answer_text(question)
    if answer_text = answer_texts.detect{|a| a.question_id == question.id}
      answer_text.value
    else
      nil
    end
  end
  
  def answers_on_current_page_valid?
    valid = true
    answers_on_current_page.each do |a|
      valid = false if !a.valid?
    end
    valid
  end
  
  def answer_texts_on_current_page_valid?
    valid = true
    answer_texts_on_current_page.each do |a|
      valid = false if !a.valid?
    end
    valid
  end
  
  def answer_dates_on_current_page_valid?
    valid = true
    answer_dates_on_current_page.each do |a|
      valid = false if !a.valid?
    end
    valid
  end
  
end
