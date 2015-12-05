require 'test_helper'

class GiftAssignerTest < ActiveSupport::TestCase
  test '.match_and_give finds a person who has not given a gift, and matches them with a person who has not received a gift' do
    chris = people(:chris)
    rob = people(:rob)

    assert_equal 0, Person.where.not(giving_to_id: nil).count
    assert_equal 0, Person.where.not(receiving_from_id: nil).count

    assert_nil chris.giving_to
    assert_nil rob.giving_to

    assert_nil chris.receiving_from
    assert_nil rob.receiving_from

    giver, recipient = GiftAssigner.match_and_give
    assert_equal recipient, giver.giving_to
    assert_equal giver, recipient.receiving_from

    assert_equal 1, Person.where.not(giving_to_id: nil).count
    assert_equal 1, Person.where.not(receiving_from_id: nil).count
  end

  test ".match_and_give cannot assign a recipient to a gift giver if the recipient is to avoided (they received a gift from this giver last year)" do
    chris = people(:chris)
    rob = people(:rob)

    assert_equal 0, Person.where.not(giving_to_id: nil).count
    assert_equal 0, Person.where.not(receiving_from_id: nil).count

    Person.where.not(id: [chris.id, rob.id]).destroy_all

    assert_nil chris.giving_to
    assert_nil rob.giving_to
    assert_nil chris.receiving_from
    assert_nil rob.receiving_from

    chris.avoid_giving_to(rob)
    rob.avoid_giving_to(chris)
    assert_nil GiftAssigner.match_and_give
  end

  test ".match_and_give_all matches people as gift givers and recipients unless there are no people without a gift, and no people not giving a gift" do
    assert_equal 0, Person.where.not(giving_to_id: nil).count
    assert_equal 0, Person.where.not(receiving_from_id: nil).count

    GiftAssigner.match_and_give_all

    assert_equal 0, Person.where(giving_to_id: nil).count
    assert_equal 0, Person.where(receiving_from_id: nil).count
  end

  test ".match_and_give_all does not assign recipients to givers if those recipients are to be avoided, for that giver" do
    assert_equal 0, Person.where.not(giving_to_id: nil).count
    assert_equal 0, Person.where.not(receiving_from_id: nil).count

    chris = people(:chris)
    tim = people(:tim)
    rob = people(:rob)
    james = people(:james)
    joanna = people(:joanna)

    chris.avoid_giving_to(joanna)
    tim.avoid_giving_to(rob)
    rob.avoid_giving_to(james)
    james.avoid_giving_to(tim)
    joanna.avoid_giving_to(chris)

    GiftAssigner.match_and_give_all

    assert_equal 0, Person.where(giving_to_id: nil).count
    assert_equal 0, Person.where(receiving_from_id: nil).count

    refute_equal joanna, chris.reload.giving_to
    refute_equal rob, tim.reload.giving_to
    refute_equal james, rob.reload.giving_to
    refute_equal time, james.reload.giving_to
    refute_equal chris, joanna.reload.giving_to
  end

  test ".match_and_give_all raises an AssignmentInfiniteLoop exception if it cannot find a suitable match within a set number of retries" do
    chris = people(:chris)
    tim = people(:tim)
    rob = people(:rob)
    james = people(:james)
    joanna = people(:joanna)

    chris.avoid_giving_to(james)
    tim.avoid_giving_to(james)
    rob.avoid_giving_to(james)
    james.avoid_giving_to(james)
    joanna.avoid_giving_to(james)

    assert_raises GiftAssigner::AssignmentInfiniteLoop do
      GiftAssigner.match_and_give_all
    end
  end

  test ".match_and_give_all does nothing if less than 2 people exist" do
    Person.where.not(id: people(:tim)).destroy_all
    refute GiftAssigner.match_and_give_all
  end
end
