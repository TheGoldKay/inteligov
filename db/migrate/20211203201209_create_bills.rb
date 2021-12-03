class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.integer :code
      t.text :name
      t.text :ementa
      t.text :bill_text_link
      t.text :date
      t.jsonb :authors
      t.jsonb :status

      t.timestamps
    end
  end
end
