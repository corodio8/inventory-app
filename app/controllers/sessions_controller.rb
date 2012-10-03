
class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:email] = 'admin'
      create_default_admin
    end
    
    admin_user = AdminUser.find_by_email(params[:email])

    if admin_user && admin_user.authenticate(params[:password])
      session[:user_id] = admin_user.id
      redirect_to root_url, notice: "Successfully logged in"
    else
      redirect_to login_path, notice: "Invalid email or password"
      flash.now.alert = "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :back
  end

  private

  def create_default_admin
    if !(AdminUser.find_by_email("admin"))
      AdminUser.new({
        :email => 'admin',
        :password => 'admin',
        :password_confirmation => 'admin'
      }).save( :validate => false)
    end
  end

end
