class Donation < ActiveRecord::Base
  belongs_to :user

  def process
    payment_hash = { amount: (self.user_bucket * 100).to_i, 
                    currency: 'usd', 
                    customer: self.user.stripe_account, 
                    description: "Thank you for donating to #{self.user.current_charity_name}", 
                    metadata:{
                      'charity EIN' => self.user.current_charity_ein, 
                      'charity name' => self.user.current_charity_name}, 
                    receipt_email: self.user.email
                   }
    Stripe::Charge.create(payment_hash)
  end

end