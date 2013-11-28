require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
  	@person_1 = Person.create(name: 'Chris', email: 'cbutcher@gmail.com')
  	@person_2 = Person.create(name: 'James', email: 'jbutcher@gmail.com')
    @person_3 = Person.create(name: 'Joanna', email: 'jbutcher@gmail.com')
    @person_4 = Person.create(name: 'Rob', email: 'jbutcher@gmail.com')
    @person_5 = Person.create(name: 'Tim', email: 'jbutcher@gmail.com')

  	@person_1.give_to(@person_2)
  end

  test 'Chris is a Person' do
    assert_equal 'Person', @person_1.class.to_s    
  end

  test 'James is a Person' do
  	assert_equal 'Person', @person_2.class.to_s
  end

  test 'Chris has a name, and it\'s Chris scrambled with md5' do
  	assert_equal Digest::MD5.hexdigest('Chris').truncate(16), @person_1.to_s  	
  end

  test 'James has a name, and it\'s James scrambled with md5' do
  	assert_equal Digest::MD5.hexdigest('James').truncate(16), @person_2.to_s
  end

  test 'Chris is not receiving a gift from anyone' do
  	assert_equal nil, @person_1.receiving_from
  end

  test 'James is not giving a gift to anyone' do
  	assert_equal nil, @person_2.giving_to
  end

  test 'Chris can give a gift to James' do  	
  	assert_equal @person_2, @person_1.giving_to
  end

  test 'James can receive a gift from Chris' do
  	assert_equal @person_1, @person_2.receiving_from
  end

  test 'automate works even if we do it like a 1000 times' do
    1000.times do
      Person.redo      
    end

    Person.all.each do |person|
      assert_not_nil person.giving_to
      assert_not_nil person.receiving_from
    end
  end

end
