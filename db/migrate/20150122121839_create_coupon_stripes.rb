class CreateCouponStripes < ActiveRecord::Migration
  def change
    create_table :coupon_stripes do |t|
      t.string :coupon_id
      t.string :coupon_release
      t.string :percent_off
      t.string :currency
      t.string :duration
      t.integer :times_redeemed
      t.boolean :coupon_valid
      t.integer :user_id

      t.timestamps
    end
  end
end
