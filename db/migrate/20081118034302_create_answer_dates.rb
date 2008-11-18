class CreateAnswerDates < ActiveRecord::Migration
  def self.up
    create_table :answer_dates do |t|
      t.references :respondent, :question
      t.datetime :value
    end
    add_index :answer_dates, :respondent_id
    add_index :answer_dates, :question_id
  end

  def self.down
    drop_table :answer_dates
  end
end
