class Question < Content
  
  after_create :set_code

  has_many :options, :order => 'options.position', :dependent => :destroy

  validates_uniqueness_of :code, :scope => :questionnaire_id, :allow_nil => true
  validates_presence_of   :code, :on => :update

  def option_attributes=(options_string)
    set_option_attributes(options_string)
  end

  def option_attributes
    get_option_attributes
  end

  def row_option_attributes=(options_string)
    set_option_attributes(options_string, 'row')
  end

  def row_option_attributes
    get_option_attributes('row')
  end

  def col_option_attributes=(options_string)
    set_option_attributes(options_string, 'col')
  end

  def col_option_attributes
    get_option_attributes('col')
  end

  def collect_headings
    headings = []
    case content_type.name
    when 'multiple_choice'
      labels = options.map(&:label)
      headings = labels.collect{|label| "#{self.code}[#{label}]"} if labels
    when 'rating_scale'
      labels = options.reject{|o| o.option_type == 'col'}.map(&:label)
      headings = labels.collect{|label| "#{self.code}[#{label}]"} if labels
    else
      headings << self.code
    end
    headings
  end

  def copy
    copy = Question.new(self.attributes.reject{|key,value| exclude_attributes_from_duplication.include?(key)})
    options.each do |option|
      copy.options.build(option.attributes.reject{|key,value| exclude_attributes_from_duplication.include?(key)})
    end
    copy
  end

  def answer_model
    question_type = QUESTIONNAIRE_CONTENT_TYPES['questions'].detect{|t| t['name'] == template}
    question_type['answer_model'] ? question_type['answer_model'] : 'Answer'
  end

protected

  def set_code(number = nil)
    update_attribute(:code, "q_#{self.id}") if code.blank?
  end

  def set_option_attributes(options_string, option_type = nil)
    if o = options.find(:first, :order => 'value desc')
      @count = o.value
    else
      @count = 0 
    end
    labels_array = options_string.split(',').each {|o| o.strip!}.uniq

    collection = option_collection(option_type)
    collection.each do |option|
      unless labels_array.include?(option.label)
        options.delete(option)
      end
    end

    labels_array.each_with_index do |label, i|
      if option = collection.detect{|o| o.label == label}
        option.update_attribute(:position, i+1)
      else
        options.build(:label => label, :position => i + 1, :option_type => option_type, :value => @count + 1)
      end
      @count += 1
    end
  end

  def option_collection(option_type)
    if option_type == 'row'
      options.option_rows
    elsif option_type == 'col'
      options.option_columns
    else
      options.option_choices
    end
  end

  def get_option_attributes(type = nil)
    options.collect{|option| option if option.option_type == type}.compact.map(&:label).join(', ')
  end
  
end
