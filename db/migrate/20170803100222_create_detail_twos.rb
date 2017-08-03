class CreateDetailTwos < ActiveRecord::Migration[5.0]
  def change
    create_table :detail_twos do |t|
      t.float :loan
      t.float :term
      t.float :rate
      t.date :disburse_date
      t.date :pay_strt_date

      t.timestamps
    end
  end
end
