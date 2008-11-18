# HAML gem and plugin are required
# textile_editor_helper plugin is required

module QuestionnaireQuestionsBuilder
  
  # ***************************************************************************************
  # Methods for displaying the content type
  # ***************************************************************************************
  
  def single_choice(question)
    # print_question_options(question, 'single_choice')
    answer = find_answer_xxx(question)
    haml_tag :ul, :class => 'options' do
      question.options.each do |option|
        haml_tag :li, :class => 'option' do
          puts radio_button_tag("#{answer_name(question, answer)}", option.id.to_s, answer.option_id == option.id && !answer.new_record?)
          haml_tag :label, option.label
        end
      end
    end
    print_validation_errors(answer)
  end
  
  def multiple_choice(question)
    # print_question_options(question, 'multiple_choice')
    haml_tag :ul, :class => 'options' do
      question.options.each do |option|
        haml_tag :li, :class => 'option' do
          answer = find_answer_xxx(question, option)
          puts check_box_tag("#{answer_name(question, answer)}[]", option.id.to_s, answer.option_id == option.id && !answer.new_record?)
          haml_tag :label, option.label
          print_validation_errors(answer)
        end
      end
    end
  end
  
  def open_single_line(question)
    answer = find_answer_xxx(question, nil, 'AnswerText')
    puts text_field_tag(answer_name(question, answer), answer.value)
  end
  
  def open_multiple_lines(question)
    answer = find_answer_xxx(question, nil, 'AnswerText')
    puts text_area_tag(answer_name(question, answer), answer.value)
  end
  
  def rating_scale(question)
    rows = question.options.option_rows
    cols = question.options.option_columns
    generate_table(question, rows, cols, 'rating_scale')
  end
  
  def semantic_differential(question)
    rows = question.options.option_rows
    cols = question.options.option_columns
    generate_table(question, rows, cols, 'semantic_differential')
  end
  
  
  # ***************************************************************************************
  # Methods for editing the content type
  # ***************************************************************************************
  
  def fields_for_single_choice(content, form_obj)
    haml_tag :div do
      puts print_question_heading_field(form_obj)
      puts print_question_hint_field(form_obj)
      puts print_question_option_attributes_field(form_obj)
      puts print_requires_answer(form_obj)
    end
  end
  
  alias_method :fields_for_multiple_choice, :fields_for_single_choice
  
  def fields_for_open_single_line(question, form_obj)
    haml_tag :div do
      puts print_question_heading_field(form_obj)
      puts print_question_hint_field(form_obj)
      puts print_requires_answer(form_obj)
    end
  end
  
  alias_method :fields_for_open_multiple_lines, :fields_for_open_single_line
  
  def fields_for_rating_scale(question, form_obj)
    haml_tag :div do
      puts print_question_heading_field(form_obj)
      puts print_question_hint_field(form_obj)
      puts form_obj.text_area(:row_option_attributes, :label => 'Row choices', :class => 's', :hint => "separate entries with a comma, eg: movie 1, movie 2, movie 3")
      puts form_obj.text_area(:col_option_attributes, :label => 'Column choices', :class => 's', :hint => "separate entries with a comma, eg: bad, ok, good")
      puts print_requires_answer(form_obj)
    end
  end
  
  def fields_for_semantic_differential(question, form_obj)
    haml_tag :div do
      puts print_question_heading_field(form_obj)
      puts print_question_hint_field(form_obj)
      puts form_obj.text_area(:row_option_attributes, :label => 'Row choices', :class => 's', :hint => "Delimite the adjective pair by '-' and separate the rows with a comma, eg: strong-weak, active-passive")
      puts form_obj.text_area(:col_option_attributes, :label => 'Column choices', :class => 's', :hint => "separate entries with a comma, eg: 1, 2, 3")
      puts print_requires_answer(form_obj)
    end
  end
  
  def fields_for_date(question, form_obj)
    haml_tag :div do
      puts print_question_heading_field(form_obj)
      puts print_question_hint_field(form_obj)
    end
    haml_tag :fieldset do
      haml_tag :legend, "Settings"
      question.settings ||= {}
      question.settings.merge!(:display => nil) unless question.settings[:display]
      airbudd_fields_for "question[settings]", question.settings do |s|
        haml_tag :div, :class => 'clear' do
          haml_tag :div, :class => 'left-half' do
            haml_tag :div, :class => 'left-half' do
              puts s.text_field(:year_from, :class => 's')
            end
            haml_tag :div, :class => 'right-half' do
              puts s.text_field(:year_to, :class => 's')
            end
          end
          haml_tag :div, :class => 'right-half' do
            haml_tag :label, "Display as"
            haml_tag :ul, :class => 'options clear' do
              puts s.radio_button(:display, :value => 'select', :label => 'Select')
              puts s.radio_button(:display, :value => 'text', :label => 'Text')
            end

          end
        end
      end
      
      
      # puts ''
    end
  end
  
  
protected
  
  # ***************************************************************************************
  # Helper methods to find the answer for a specific question
  # ***************************************************************************************
  
  
  # find answer by question and respondent
  # if it is a multiple choice then find the answer by option instead of question
  # if it is a rating scale then find the answer by question and row
  # def find_answer_xxx(question, key = nil, model = "Answer")
  #   begin
  #     # make sure the answers are assigned in the controller
  #     # eg @answers, @answer_texts, etc.
  #     answers = instance_variable_get("@#{model.underscore.pluralize}")
  #     # debugger
  #     case question.template
  #     when 'multiple_choice'
  #       answers.detect {|a| a.option_id == key.id}
  #     when 'rating_scale'
  #       answers.detect{|a| a.question_id == question.id && a.row_id == key.id}
  #     else
  #       answers.detect {|a| a.question_id == question.id}
  #     end
  #   rescue
  #     model.constantize.new
  #   end
  # end
  
  def find_answer_xxx(question, key = nil, model = "Answer")
    begin
      case question.template
      when 'multiple_choice'
        # @answers[model.underscore.pluralize.to_sym].detect {|a| a.option_id == key.id}
        answer = @respondent.answers_on_current_page.detect {|a| a.option_id == key.id}
      when 'rating_scale', 'semantic_differential'
        # @answers[model.underscore.pluralize.to_sym].detect{|a| a.question_id == question.id && a.row_id == key.id}
        unless answer = @respondent.answers_on_current_page.detect{|a| a.question_id == question.id && a.row_id == key.id}
          answer = Answer.new(:question => question, :row_id => key_id)
        end
      when 'open_single_line', 'open_multiple_lines'
        answer = @respondent.answer_texts_on_current_page.detect {|a| a.question_id == question.id}
      when 'date'
        answer = @respondent.answer_dates_on_current_page.detect {|a| a.question_id == question.id}
      else
        answer = @respondent.answers_on_current_page.detect {|a| a.question_id == question.id}
      end
      # answer.nil? ? model.constantize.new(:question => question) : answer
      answer ||= model.constantize.new(:question => question)
    rescue
      # This is used in design mode: chataca.com/surveys/123
      # Because there are no answers available in Design mode
      model.constantize.new(:question => question)
    end
  end
  
  # set the name of the attribute
  def answer_name(question, answer)
    prefix = answer.new_record? ? 'new' : 'existing'
    model = answer.class.name.underscore
    id = answer.new_record? ? question.id : answer.id
    "respondent[#{prefix}_#{model}_attributes][#{id}]"
  end
  
  
  
  # ***************************************************************************************
  # Fields for editing the content attributes
  # ***************************************************************************************
  
  # edit question heading
  # edit question's text method
  def print_question_heading_field(obj)
    haml_tag :p do
      haml_tag :label, 'Question (format with Textile)'
      puts find_and_preserve(textile_editor('question', 'text', :class => 's', :onbeforepaste => "adjustTextarea(this, 60)", :oninput => "adjustTextarea(this, 60)", :onkeypress => "adjustTextarea(this, 60)"))
      # if defined? TextileEditorHelper
      #   puts find_and_preserve(textile_editor('question', 'text', :class => 's'))
      # else
      #   puts obj.text_area(:text, :class => 's')
      # end
    end
  end
  
  # edit question's hint method
  def print_question_hint_field(obj)
    obj.text_field :hint, :class => 'l'
  end
  
  # edit question's option_attributes method
  def print_question_option_attributes_field(obj)
    obj.text_area :option_attributes, :label => 'Options', :class => 's', :hint => "separate entries with a comma"
  end
  
  def generate_table(question, rows, cols, template)
    haml_tag :table do
      haml_tag :thead do
        haml_tag :tr do
          haml_tag :th
          cols.each do |col|
            haml_tag :th, :style => 'text-align:center;' do
              puts h(col.label)
            end
          end
          haml_tag :th if template == 'semantic_differential'
        end
      end
      rows.each do |row|
        answer = find_answer_xxx(question, row)
        haml_tag :tr do
          if template == 'semantic_differential'
            label = h(row.label.split('-')[0])
          else
            label = h(row.label)
          end
          
          haml_tag :td, :style => 'text-align:right;' do
            puts label
            haml_tag :br
            print_validation_errors(answer)
          end
          
          columns_count = cols.length
          columns_count += template == 'semantic_differential' ? 2 : 1
          
          cols.each do |col|
            name = answer_name(question, answer)
            selected = answer.row_id == row.id && answer.col_id == col.id && !answer.new_record?
            haml_tag :td, :style => "width:#{100/(columns_count)}%;text-align:center;" do
              puts radio_button_tag("#{name}[#{row.id}]", col.id.to_s, selected)
            end
          end
          
          if template == 'semantic_differential'
            haml_tag :td, :style => 'text-align:left;' do
              puts h(row.label.split('-')[1])
            end
          end
          
        end
      end
    end
  end
  
  def print_requires_answer(obj)
    haml_tag :ul, :class => 'options' do
      puts obj.check_box(:requires_answer, :label => 'Answer required?')
    end
  end
  
  def print_validation_errors(answer)
    if answer.errors.any?
      haml_tag :span, :class => 'feedback' do
        puts answer.errors.full_messages.to_sentence
      end
    end
  end
  
end

