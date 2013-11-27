# == Schema Information
#
# Table name: people
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  email             :string(255)
#  giving_to_id      :integer
#  receiving_from_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#  wishlist          :string(255)
#

class Person < ActiveRecord::Base
	has_one :giving_to, class_name: 'Person', foreign_key: 'receiving_from_id'
	has_one :receiving_from, class_name: 'Person', foreign_key: 'giving_to_id'

	def to_s
		name
	end

	def give_to(recipient)
		self.giving_to = recipient
		recipient.receiving_from = self

		self.save
		recipient.save
	end

	def self.redo
		Person.reset_gives
		Person.automatch
	end

	def self.match_and_give
		people_who_havent_given = Person.where(giving_to_id: nil)
		@person_1 = people_who_havent_given.sample

		if @person_1
			people_who_havent_received = Person.where(receiving_from_id: nil).where.not(id: @person_1.id)
			@person_2 = people_who_havent_received.sample
		end

		if @person_1 && @person_2
			@person_1.give_to(@person_2)
		else
			raise Exception, 'End of list or odd number'
		end

		if Person.where(giving_to_id: nil, receiving_from_id: nil) != []
			Person.match_and_give
		end
	end

	def self.email_everyone
		people = Person.all

		people.each do |person|
			GiftMailer.gift_email(person).deliver
		end
	end

	def self.automatch
		keep_looping = true

		while keep_looping do
			begin
				Person.match_and_give
			rescue Exception => e
				keep_looping = false
			end
		end


	end

	def self.reset_gives
		people = Person.all

		people.each do |person|
			person.giving_to_id = nil
			person.receiving_from_id = nil
			person.save
		end
	end

	def self.even_or_odd
		Person.count % 2 == 0 ? 'Even' : 'Odd'
	end
end
9
