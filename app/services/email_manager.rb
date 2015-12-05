class EmailManager
  def self.email_person(person)
    return if person.giving_to.nil? || person.receiving_from.nil?
    GiftMailer.gift_email(person).deliver
    true
  end

  def self.email_everyone
    return unless Person.all_giving_and_receiving?

    Person.all.each do |person|
      GiftMailer.gift_email(person).deliver
    end

    true
  end
end
