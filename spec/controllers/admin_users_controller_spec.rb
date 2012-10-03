require 'spec_helper'

describe AdminUsersController do

  #login as default admin
  def valid_session
#   session[:user_id] = FactoryGirl.create(:admin_enabled_user).id
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:admin_user =>
          {
           :email => 'example@example.com',
           :password => 'password',
           :password_confirmation => 'password'
          }
        }, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created admin_user as @admin_user" do
        post :create, {:admin_user => FactoryGirl.attributes_for(:admin_user)}, valid_session
        assigns(:admin_user).should be_a(AdminUser)
        assigns(:admin_user).should be_persisted
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stubs(:save).returns(false)
        post :create, {:admin_user => {}}, valid_session
        assigns(:admin_user).should be_a_new(AdminUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stubs(:save).returns(false)
        post :create, {:admin_user => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "GET 'index'" do
    describe "without being logged in (no user_id)" do
      it "redirects to root" do
      end
    end
    describe "with being logged in" do
      it "renders the page and grabs all admin_user objects" do
      end
    end
  end

end
