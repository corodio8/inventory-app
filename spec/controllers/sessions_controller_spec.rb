require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    describe 'as an admin_user' do
      describe 'with invalid credentials' do
        it 'fails to authenticate'
        it 'does not create a session'
      end

      describe 'with valid credentials' do
        it 'successfully authenticates'
        it 'creates a sessions with admin_user_id'
      end
    end
    
    describe 'as default administrator' do
      describe 'with none existing' do
        describe 'with default credentials' do
          it 'creates an admin object with default password'
          it 'it successfully authenticates'
        end
        describe 'with random credentials' do
          it 'creates an admin object with default password'
          it 'fails it authenticate'
        end
      end
      describe 'with object already created' do
        describe 'with valid credentials' do
          it 'successfully authenticates'
          it 'creates a session with proper admin_usr_id'
        end
      end
    end
  end


end
