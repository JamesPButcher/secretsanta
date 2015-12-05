require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def giver
    @giver ||= people(:chris)
  end

  def recipient
    @recipient ||= people(:rob)
  end

  def avoided_recipient
    @avoided_recipient ||= people(:tim)
  end

  setup do
    giver.give_to(recipient)
    giver.avoid_giving_to(avoided_recipient)
    giver.reload
  end

  test 'Chris has a name, and it\'s Chris scrambled with md5' do
    assert_equal Digest::MD5.hexdigest('Chris').truncate(16), giver.to_s
  end

  test 'Rob has a name, and it\'s Rob scrambled with md5' do
    assert_equal Digest::MD5.hexdigest('Rob').truncate(16), recipient.to_s
  end

  test 'Chris is not receiving a gift from anyone' do
    assert_equal nil, giver.receiving_from
  end

  test 'Rob is not giving a gift to anyone' do
    assert_equal nil, recipient.giving_to
  end

  test 'Chris is giving a gift to Rob' do
    assert_equal recipient, giver.giving_to
  end

  test 'Rob is receiving a gift from Chris' do
    assert_equal giver, recipient.receiving_from
  end

  test 'Chris gave a gift to Tim last year, and is avoiding giving him a gift this year' do
    assert_equal giver.avoiding_giving_to, avoided_recipient
  end

  test '.all_giving_and_receiving? returns true if everyone is receiving and giving a gift' do
    GiftAssigner.match_and_give_all
    assert Person.all_giving_and_receiving?
  end

  test '.all_giving_and_receiving? returns false if everyone is receiving and giving a gift' do
    refute Person.all_giving_and_receiving?
  end

  test 'a new Person record is valid if it has an email_confirmation that matches its email' do
    valid_person = Person.create(name: 'Some guy',
                                 email: 'email@email.com',
                                 email_confirmation: 'email@email.com',
                                 wishlist: 'Nintendo')

    assert valid_person.valid?
  end

  test 'a new Person record is invalid if it has an email_confirmation that does not match its email' do
    valid_person = Person.create(name: 'Some guy',
                                 email: 'email@email.com',
                                 email_confirmation: 'typo@email.com',
                                 wishlist: 'Nintendo')

    refute valid_person.valid?
  end

  test 'a new Person record is valid if it has a well-formatted email' do
    valid_person = Person.create(name: 'Some guy',
                                 email: 'email@email.com',
                                 email_confirmation: 'email@email.com',
                                 wishlist: 'Nintendo')

    assert valid_person.valid?
  end

  test 'a new Person record is invalid if it does not have a well-formatted email' do
    valid_person = Person.create(name: 'Some guy',
                                 email: 'some nonstandard email',
                                 email_confirmation: 'typo@email.com',
                                 wishlist: 'Nintendo')

    refute valid_person.valid?
  end
end
