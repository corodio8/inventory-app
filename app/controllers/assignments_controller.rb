
class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.json
  
  @@start_of_time = ('01/01/1337'.to_date)
  @@end_of_time = ('01/01/4000'.to_date)

  #shows currently assigned assets
  def index
    @assignments = []
    #for each asset, find all assignments applied, order by date and select entry, which would be current
    @computers = Computer.all
    Computer.all.each do |asset|
      if (latest_assignment = Assignment.where(:computer_id => asset.id).order("assign_date ASC").last)
        @assignments << latest_assignment 
      else
        flash[:alert] = "Warning: Asset with tag #{asset.asset_tag} does not have any assignments. Please assign it to IT if it is not in use."
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignments }
      format.xls { send_data @assignments.to_xls }
    end
  end

  #shows ALL past assignments
  def history
    @assignments = Assignment.order("assign_date ASC")
  end

  #test action
  def debug
    @assignments = Assignment.first.build_computer
  end

  #assigns a computer object to selected user with assign_date
  def new
    
    #searches computer_id and then sorts by assign_date
    #then checks to see if that assignment matches user_id, if its does then 
    #it is already current and rejects assignment request

    #finds the latest assignment for particular computer id and assigns it, otherwise just create new object
    if (@latest_assignment = Assignment.where(:computer_id => params[:computer_id]).order("assign_date ASC").last)

      #checks if user_id matches current user_id, if so then record is already current and reject assignment
      if (@latest_assignment.user_id != params[:user_id].to_i)
        if (@latest_assignment.assign_date != Date.today) or true
          @assignment = Assignment.new({:assign_date => params[:assign_date]})
          @assignment.user_id = params[:user_id]
          @assignment.computer_id = params[:computer_id]
          if @assignment.save
          flash[:notice] = "Asset successfully assigned"
            respond_to do |format|
              format.html { redirect_to assignments_url }
              format.json { head :no_content }
            end
          else
            redirect_to request.referer
          end
        else
          flash[:notice] = ("Could not assign asset, already assigned once today, please delete latest assignment first")
          redirect_to :back 
        end
      else
        flash[:notice] = ("Could not assign asset, already current")
        redirect_to :back 
      end

    #Case first assignment for a computer, this should only happen on computer creation
    else 
      @assignment = Assignment.new({:assign_date => params[:assign_date]})
      @assignment.user_id = params[:user_id]
      @assignment.computer_id = params[:computer_id]
      if @assignment.save
        flash[:notice] = "Initial assignment successful"
        respond_to do |format|
          format.html { redirect_to assignments_url }
          format.json { head :no_content }
        end
      else
        flash[:notice] = ("Unspecified Error Occurred")
        redirect_to :back #attach_user_path(params[:user_id], :notice => 'Invalid') 
      end
    end
  end


  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.json
#  def new
#    @assignment = Assignment.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @assignment }
#    end
#  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
  end

  # POST /assignments
  # POST /assignments.json
#  def create
#    @assignment = Assignment.new(params[:assignment])
#
#    respond_to do |format|
#      if @assignment.save
#        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
#        format.json { render json: @assignment, status: :created, location: @assignment }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @assignment.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes({:assign_date => format_date(params[:assignment][:assign_date])})
        format.html { redirect_to @assignment, notice: "Assign date was successfully changed to #{params[:assignment][:assign_date]}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url }
      format.json { head :no_content }
  end
  end
  
  def report_query
  
    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

  def show_report_temp_debug
    @user_id = User.where(:fname => params[:fname]).first
    @assignments = Assignment.where(:user_id => @user_id)
  end
  
  def report
    #initializes @assignments to nil
    @assignments = nil

    #filter by first name
    if !params[:fname].empty?
      @user_ids = User.where{fname.like my{"%#{params[:fname]}%"} }
      user_ids = []
      @user_ids.each { |user| user_ids << user.id }
      #since this is first test, this will never be true
      if @assignments
        @assignments = @assignments.where{user_id.like_any user_ids}
      else
        @assignments = Assignment.where{user_id.like_any user_ids}
      end
    end

    #filter by last name
    if !params[:lname].empty?
      @user_ids = User.where{lname.like my{"%#{params[:lname]}%"} }
        user_ids = []
        @user_ids.each { |user| user_ids << user.id }
      if @assignments
        @assignments = @assignments.where{user_id.like_any user_ids}
      else
        @assignments = Assignment.where{user_id.like_any user_ids}
      end
    end

    #filter by range
    #check that BOTH exist, else fail
    if !(params[:start_date].empty? || params[:end_date].empty?)
      #check if assignment has been initialized, if not then create, if so then filter
      start_date = Date.strptime(params[:start_date], '%m-%d-%Y')
      end_date = Date.strptime(params[:end_date], '%m-%d-%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => start_date..end_date)
      else
        @assignments = Assignment.where(:assign_date => start_date..end_date)
      end
    elsif params[:start_date].empty? && !params[:end_date].empty?
      end_date = Date.strptime(params[:end_date], '%m-%d-%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => @@start_of_time..end_date)
      else
        @assignments = Assignment.where(:assign_date => @@start_of_time..end_date)
      end
    elsif !params[:start_date].empty? && params[:end_date].empty?
      start_date = Date.strptime(params[:start_date], '%m-%d-%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => start_date..@@end_of_time)
      else
        @assignments = Assignment.where(:assign_date => start_date..@@end_of_time)
      end
    end

    # END FILTERS
    # BEGIN TRANSFER OPTIONS
    
    #skip entire block if assignments is nil
    if !@assignments.nil? 
      if params[:transfer] == '1'
        @master_list = Assignment.all
        #The index of transfer_list corresponds to the id of eac model in assigments, which is the set returned by the query
        #The content of the array holds the Assignment object which is the last asignment previous to the @assignment one
        #hence the transferred-from object.
        @transfer_list = []
        #transfer_names is the translation from transfer_list to the corresponding user name
        @transfer_names = []
        @assignments.each do |model|
          @transfer_list[model.id] = Assignment.where(:computer_id => model.computer_id).where(
                                     :assign_date => @@start_of_time...model.assign_date).order("assign_date ASC").last
          if !@transfer_list[model.id].nil?
            @transfer_names[model.id] = User.find(@transfer_list[model.id].user_id).fname + " " + User.find(@transfer_list[model.id].user_id).lname
          end
        end
      end

      @report = []
      if params[:format] == 'xls' || params[:format] == 'csv'
        #initialize fields
        index = 0
    
        @assignments.each do |assignment|
          @report[index] = { 'First Name' => User.find(assignment.user_id).fname,
            'Last Name' => User.find(assignment.user_id).lname,
            'Asset Tag' => Computer.find(assignment.computer_id).asset_tag,
            'Assign Date' => assignment.assign_date }
          index += 1
        end
      end
    end

    respond_to do |format|
      if @assignments.nil?
        format.html { redirect_to report_query_assignments_path, notice: "Cannot submit empty form" }
      else
        format.html # show.html.erb
        format.json { render json: @assignments }
        format.xls  { send_data report_to_csv(col_sep: "\t"), :filename => 'report.xls' }
        format.csv { send_data report_to_csv, :filename => 'report.csv' }
      end
    end

  end


end

private

#method to generate report csv
def report_to_csv(options = {})
  if !@report.empty?  
    CSV.generate(options) do |csv|
      csv << @report[0].keys
      @report.each do |assignment|
        csv << assignment.values
      end
    end
  end
end

#helper to return full name of user
def user_full_name
end

def format_date(date)
      Date.strptime(date, '%m-%d-%Y')
end
