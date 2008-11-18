class CreateRespondents < ActiveRecord::Migration
  def self.up
    create_table :respondents do |t|
      t.references :questionnaire
      t.string :ip_address
      t.datetime :created_at, :started_at, :completed_at
    end
    add_index :respondents, :questionnaire_id
    add_index :respondents, :completed_at
  end

  def self.down
    drop_table :respondents
  end
end
