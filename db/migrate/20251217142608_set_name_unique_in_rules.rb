class SetNameUniqueInRules < ActiveRecord::Migration[8.0]
  def change
    change_column_null :rules, :name, false
    add_index :rules, :name, unique: true
  end
end
