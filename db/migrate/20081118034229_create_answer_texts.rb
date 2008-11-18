class CreateAnswerTexts < ActiveRecord::Migration
  def self.up
    create_table :answer_texts do |t|
      t.references :respondent, :question
      t.text :value
    end
    add_index :answer_texts, :respondent_id
    add_index :answer_texts, :question_id
  end

  def self.down
    drop_table :answer_texts
  end
end
