class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.references :respondent, :question, :option
      t.integer :row_id, :col_id
    end
    add_index :answers, :respondent_id
    add_index :answers, :question_id
    add_index :answers, :option_id
  end

  def self.down
    drop_table :answers
  end
end
