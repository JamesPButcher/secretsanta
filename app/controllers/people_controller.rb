class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :email]
  skip_before_action :restrict_unless_admin, only: [:index, :new, :create, :admin, :admin_login]

  def self.user_password
    Rails.env.test? ? 'password' : ENV['USER_PASSWORD']
  end

  http_basic_authenticate_with name: "xmas", password: user_password

  def admin
  end

  def admin_login
    if params[:password] == (Rails.env.test? ? 'admin_password' : ENV['ADMIN_PASSWORD'])
      session[:admin] = true
    else
      session[:admin] = nil
    end

    redirect_to root_path
  end

  def reset
    Person.reset_gives
    redirect_to people_path
  end

  def automatch
    Person.reset_gives

    if GiftAssigner.match_and_give_all
      redirect_to people_path, notice: "Successfully matched everyone"
    else
      redirect_to people_path, alert: "Could not match everyone"
    end
  end

  def email
    if EmailManager.email_person(@person)
      redirect_to people_path, notice: "Successfully emailed #{@person.name}"
    else
      redirect_to people_path, alert: "Failed to send email to #{@person.email}"
    end
  end

  def email_everyone
    if EmailManager.email_everyone
      redirect_to people_path, notice: 'Successfully emailed everyone'
    else
      redirect_to people_path, alert: 'Failed to send emails, someone doesn\'t have a giver or recipient'
    end
  end

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render action: 'show', status: :created, location: @person }
      else
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :email, :giving_to_id, :receiving_from_id, :wishlist, :avoiding_giving_to_id)
    end
end
