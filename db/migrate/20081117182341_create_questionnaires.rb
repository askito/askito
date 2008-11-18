class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.references :user
      t.string :type, :title
      t.string :caption
      t.text :description

      t.timestamps
    end
    add_index :questionnaires, :user_id
    add_index :questionnaires, :title
  end

  def self.down
    drop_table :questionnaires
  end
end
