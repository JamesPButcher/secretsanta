ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => 'smtp.mailgun.org',
  :user_name      => 'postmaster@app19873111.mailgun.org',
  :password       => 'bd5942ecacc6ecda5b9af681097b201b',
  :domain         => 'butcher-xmas.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp
