class GiftAssigner
  class AssignmentInfiniteLoop < StandardError; end
  MATCH_RETRY_COUNT = 100.freeze
  RESET_RETRY_COUNT = 10.freeze

  def self.match_and_give
    return unless gift_giver = Person.people_who_havent_given.sample

    excluded_recipient_ids = [gift_giver.id]
    excluded_recipient_ids << gift_giver.avoiding_giving_to.id if gift_giver.avoiding_giving_to

    return unless gift_recipient = Person.people_who_have_not_received(excluded_ids: [excluded_recipient_ids]).sample

    gift_giver.give_to(gift_recipient)
    [gift_giver, gift_recipient]
  end

  def self.match_and_give_all
    RESET_RETRY_COUNT.times do |i|
      MATCH_RETRY_COUNT.times do
        break unless GiftAssigner.match_and_give
      end

      raise AssignmentInfiniteLoop.new if i == RESET_RETRY_COUNT - 1

      if Person.all_giving_and_receiving?
        break
      else
        Person.reset_gives
      end
    end
  end
end
