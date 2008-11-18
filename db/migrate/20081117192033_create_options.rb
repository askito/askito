class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.references    :question
      t.string        :label, :option_type
      t.integer       :value
      t.integer       :position, :default => 1
      t.integer       :answers_count, :default => 0

      t.timestamps
    end
    add_index :options, :question_id
  end

  def self.down
    drop_table :options
  end
end
