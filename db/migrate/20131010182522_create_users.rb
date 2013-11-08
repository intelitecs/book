class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :done , default: false
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
