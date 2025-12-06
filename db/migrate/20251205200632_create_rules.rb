class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules do |t|
      t.string :field,    null: false
      t.string :operator, null: false
      t.string :value,    null: false
      t.string :name,     null: false

      t.timestamps
    end
  end
end
