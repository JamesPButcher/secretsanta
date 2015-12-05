require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("xmas", "password")
    session[:admin] = true
  end

  def person
    @person ||= people(:chris)
  end

  def other_person
    @other_person ||= people(:rob)
  end

  test "#index responds OK if the user is logged in as user" do
    get :index
    assert_response :ok
  end

  test "#index responds Access Denied if the user is not logged in as user" do
    request.env['HTTP_AUTHORIZATION'] = nil
    get :index
    assert_response :unauthorized
  end

  test "#index responds OK if the user visits the page with a valid access token" do
    get :index, access_token: 'access_token'
    assert_response :ok
  end

  test "#index responds Access Denied if the user visits the page with an invalid access token" do
    request.env['HTTP_AUTHORIZATION'] = nil
    get :index, access_token: 'foo'
    assert_response :unauthorized
  end

  test "#edit responds OK if the user is an admin" do
    get :edit, id: person.id
    assert_response :ok
  end

  test "#edit redirects to the root path if the user is not an admin" do
    session[:admin] = nil
    get :edit, id: person.id
    assert_redirected_to root_path
  end

  test "#reset deletes all gift assignments" do
    person.give_to(other_person)
    assert_equal other_person, person.giving_to

    post :reset
    assert_redirected_to people_path

    assert_nil person.reload.giving_to
    assert_equal 0, Person.where.not(giving_to_id: nil, receiving_from_id: nil).count
  end

  test "#admin responds OK if the user is logged in as user" do
    get :admin
    assert_response :ok
  end

  test "#admin responds Access Denied if the user is not logged in as user" do
    request.env['HTTP_AUTHORIZATION'] = nil
    get :admin
    assert_response :unauthorized
  end

  test "#admin logging in with the correct password sets the admin session variable to true" do
    post :admin_login, password: 'admin_password'
    assert session[:admin]
    assert_redirected_to root_path
  end

  test "#admin logging in with an incorrect password sets the admin session variable to false" do
    post :admin_login, password: 'foo'
    refute session[:admin]
    assert_redirected_to root_path
  end

  test "#email_person emails a particular person" do
    EmailManager.expects(:email_person).with(person).returns(true)
    post :email, id: person.id
    assert_redirected_to people_path
    assert_match /Successfully/, flash[:notice]
  end

  test "#email_person may fail to send someone an email" do
    EmailManager.expects(:email_person).with(person).returns(false)
    post :email, id: person.id
    assert_redirected_to people_path
    assert_match /Failed/, flash[:alert]
  end

  test "#email_everyone emails everyone" do
    EmailManager.expects(:email_everyone).returns(true)
    post :email_everyone
    assert_redirected_to people_path
    assert_match /Successfully/, flash[:notice]
  end

  test "#email_everyone might fail to email everyone" do
    EmailManager.expects(:email_everyone).returns(false)
    post :email_everyone
    assert_redirected_to people_path
    assert_match /Failed/, flash[:alert]
  end
end
