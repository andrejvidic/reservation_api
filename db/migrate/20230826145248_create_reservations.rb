class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :status
      t.string :currency
      t.decimal :payout_price
      t.decimal :security_price
      t.decimal :total_price

      t.timestamps
    end
  end
end
