class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :street
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country

      t.timestamps
    end
  end
end