class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :article, index: true
      t.text :body
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
