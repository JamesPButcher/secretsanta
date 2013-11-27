require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
  	@person_1 = Person.create(name: 'Chris', email: 'cbutcher@gmail.com')
  	@person_2 = Person.create(name: 'James', email: 'jbutcher@gmail.com')

  	@person_1.give_to(@person_2)
  end

  test 'Chris is a Person' do
    assert_equal 'Person', @person_1.class.to_s    
  end

  test 'James is a Person' do
  	assert_equal 'Person', @person_2.class.to_s
  end

  test 'Chris has a name, and it\'s Chris' do
  	assert_equal 'Chris', @person_1.to_s  	
  end

  test 'James has a name, and it\'s James' do
  	assert_equal 'James', @person_2.to_s
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

end
