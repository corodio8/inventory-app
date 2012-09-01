
class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.json
  
  @@start_of_time = ('01/01/1337'.to_date)
  @@end_of_time = ('01/01/4000'.to_date)

  #shows currently assigned assets
  def index
    @assignments = Array.new
    #for each asset, find all assignments applied, order by date and select entry, which would be current
    Computer.all.each do |asset|
      @assignments <<  Assignment.where(:computer_id => asset.id).order("assign_date ASC").last
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
    @assignments = Assignment.all
  end

  #assigns a computer object to selected user with assign_date
  def new
    
    #searches computer_id and then sorts by assign_date
    #then checks to see if that assignment matches user_id, if its does then 
    #it is already current and rejects assignment request

    #finds the latest assignment for particular computer id and assigns it, otherwise fail.
    if (@assignment = Assignment.where(:computer_id => params[:computer_id]).order("assign_date ASC").last)

      #checks if user_id matches current user_id, if so then record is already current and reject assignment
      if not @assignment.user_id == params[:user_id]
        @assignment = Assignment.new

        @assignment.update_attributes(:user_id => params[:user_id],
                                 :computer_id => params[:computer_id],
                                 :assign_date => params[:assign_date])
        respond_to do |format|
          format.html { redirect_to assignments_url }
          format.json { head :no_content }
        end
      else
        flash[:notice] = ("Could not assign asset, already current")
        redirect_to attach_user_path(params[:user_id], :notice => 'Invalid') 
      end
    else
      flash[:notice] = ("Could not assign asset, already current")
      redirect_to attach_user_path(params[:user_id], :notice => 'Invalid') 
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
  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        format.json { render json: @assignment, status: :created, location: @assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
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
      @user_id = User.where(:fname => params[:fname]).first
      if @assignments
        @assignments = @assignments.where(:user_id => @user_id)
      else
        @assignments = Assignment.where(:user_id => @user_id)
      end
    end

    #filter by last name
    if !params[:lname].empty?
      @user_id = User.where(:lname => params[:lname]).first
      if @assignments
        @assignments = @assignments.where(:user_id => @user_id)
      else
        @assignments = Assignment.where(:user_id => @user_id)
      end
    end

    #filter by range
    #check that BOTH exist, else fail
  if !(params[:start_date] && params[:end_date]).empty?
      #check if assignment has been initialized, if not then create, if so then filter
      start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
      end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => start_date..end_date)
      else
        @assignments = Assignment.where(:assign_date => start_date..end_date)
      end
    elsif params[:start_date].empty? && !params[:end_date].empty?
      end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => @@start_of_time..end_date)
      else
        @assignments = Assignment.where(:assign_date => @@star_of_time..end_date)
      end
    elsif !params[:start_date].empty? && params[:end_date].empty?
      start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
      if @assignments
        @assignments = @assignments.where(:assign_date => start_date..@@end_of_time)
      else
        @assignments = Assignment.where(:assign_date => start_date..@@end_of_time)
      end
    end

    # END FILTERS
    # BEGIN TRANSFER OPTIONS
    
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

    @test_array = [Assignment.find(6), Assignment.find(7)]
 
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignments }
      format.xls  { send_data report_to_csv(col_sep: "\t"), :filename => 'report.xls' }
      format.csv { send_data report_to_csv, :filename => 'report.csv' }
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

