require 'test_helper'

class EmailManagerTest < ActiveSupport::TestCase
  test '.email_person emails a person if they are giving to someone, and receiving from someone' do
    chris = people(:chris)
    rob = people(:rob)
    joanna = people(:joanna)

    chris.give_to(rob)
    joanna.give_to(chris)

    GiftMailer.expects(:gift_email).with(chris).returns(mock(deliver: true))
    assert EmailManager.email_person(chris)
  end

  test '.email_person does not email if a person if they are not giving to someone' do
    chris = people(:chris)
    joanna = people(:joanna)

    joanna.give_to(chris)

    GiftMailer.expects(:gift_email).never
    refute EmailManager.email_person(chris)
  end

  test '.email_person does not email if a person if they are not receiving from someone' do
    chris = people(:chris)
    joanna = people(:joanna)

    chris.give_to(joanna)

    GiftMailer.expects(:gift_email).never
    refute EmailManager.email_person(chris)
  end

  test '.email_everyone emails everyone, if everyone is giving to someone, and receiving from someone' do
    GiftAssigner.match_and_give_all
    GiftMailer.expects(:gift_email).times(Person.count).returns(stub(deliver: true))
    assert EmailManager.email_everyone
  end

  test '.email_everyone does not emails everyone, if someone is not giving to someone' do
    GiftAssigner.match_and_give_all
    chris = people(:chris)
    chris.update_attributes!(giving_to_id: nil)

    GiftMailer.expects(:gift_email).never
    refute EmailManager.email_everyone
  end

  test '.email_everyone does not emails everyone, if someone is not reciving from someone' do
    GiftAssigner.match_and_give_all
    chris = people(:chris)
    chris.update_attributes!(receiving_from_id: nil)

    GiftMailer.expects(:gift_email).never
    refute EmailManager.email_everyone
  end
end
