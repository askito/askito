class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.references :questionnaire
      t.string        :type, :template, :limit => 50
      t.integer       :position, :default => 1
      t.text          :text, :settings
      
      # Attributes for questions
      t.string        :hint, :code
      t.boolean       :requires_answer
      
      t.timestamps
    end
    add_index :contents, :questionnaire_id
  end

  def self.down
    drop_table :contents
  end
end
