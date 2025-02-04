class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, foreign_key: true, null: false
      t.references :admin_user, foreign_key: true, null: true
      t.text :question, null: false
      t.text :answer, null: true

      t.timestamps
    end
  end
end
