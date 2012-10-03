class AdminUsersController < ApplicationController
  
#  before_filter :authorize
  
  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(params[:admin_user])
    if @admin_user.save
      redirect_to admin_users_path, notice: "administrative user created"
    else
      render "new"
    end
  end

  def index 
    @admin_users = AdminUser.all
  end

  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  def update
    @admin_user = AdminUser.find(params[:id])
    
    respond_to do |format|
      if @admin_user.update_attributes(params[:admin_user])
        format.html { redirect_to admin_users_path, notice: 'Computer was successfully updated.' }
      else
        format.html { render action: "edit" } 
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_user = AdminUser.find(params[:id])
    admin_user_email = @admin_user.email
    @admin_user.destroy

    respond_to do |format|
      format.html { redirect_to index, notice: "#{admim_user_email} has been destroyed!" }
    end
  end

end

