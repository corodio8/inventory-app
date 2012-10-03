class ApplicationController < ActionController::Base
  protect_from_forgery

  def authorize
    if current_user.nil?
      redirect_to login_path, alert: "Not Authorized, Please Log in."
    end
  end

  def current_user
    @current_user ||= AdminUser.find(session[:user_id]) if session[:user_id]
  end

  def create_assignment(params)
    
    #searches computer_id and then sorts by assign_date
    #then checks to see if that assignment matches user_id, if its does then 
    #it is already current and rejects assignment request

    #finds the latest assignment for particular computer id and assigns it, otherwise just create new object
    if !(@latest_assignment = Assignment.where(:computer_id => params[:computer_id]).order("assign_date ASC").last).nil?

      #checks if user_id matches current user_id, if so then record is already current and reject assignment
      if (@latest_assignment.user_id != params[:user_id].to_i)
        if (@latest_assignment.assign_date != Date.today)
          @assignment = Assignment.new({:assign_date => params[:assign_date]})
          @assignment.user_id = params[:user_id]
          @assignment.computer_id = params[:computer_id]
          if @assignment.save
            flash[:notice] = "Asset successfully assigned"
            @assignment_saved ||= true;
          else
            @assignment_saved ||= false;
          end
        else
          flash[:alert] = ("Could not assign asset, already assigned once today, please delete latest assignment first")
          @assignment_saved ||= false;
        end
      else
        flash[:alert] = ("Could not assign asset, already current #{@latest_assignment.class}")
        @assignment_saved ||= false;
      end

    #Case first assignment for a computer, this should only happen on computer creation
    else 
      @assignment = Assignment.new({:assign_date => params[:assign_date]})
      @assignment.user_id = params[:user_id]
      @assignment.computer_id = params[:computer_id]
      if @assignment.save
        flash[:notice] = ("Default assignment created successfully")
        @assignment_saved ||= true  
      else
        flash[:alert] = ("Unspecified Error Occurred")
        @assignment_saved ||= false
      end
    end
  end
 
  helper_method :create_assignment
  helper_method :current_user
end
