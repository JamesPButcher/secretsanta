# ActionMailer::Base.smtp_settings = {
#   :port           => 587,
#   :address        => ENV['MAILGUN_SMTP_SERVER'],
#   :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
#   :password       => ENV['MAILGUN_SMTP_PASSWORD'],
#   :domain         => 'butcher-xmas.heroku.com',
#   :authentication => :plain,
# }
# ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'christophrb.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
