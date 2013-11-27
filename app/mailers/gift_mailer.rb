class GiftMailer < ActionMailer::Base
  	default from: "cbutcher@gmail.com"

   	def gift_email(person)
    	@person = person
    	mail(to: @person.email, subject: 'You are a Secret Santa!')
  	end
end
