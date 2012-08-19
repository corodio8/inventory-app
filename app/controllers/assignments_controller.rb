
class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.json
  
  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignments }
    end
  end

  #test action
  def happy
  end

  #assigns a computer object to selected user with current date
  def assign_computer_to_user
    #tests if assignment is current
    if Assignment.where(:user_id => params[:user_id],
                        :computer_id => params[:computer_id] ).first.nil?
     
   @assignment = Assignment.new                                               
   @assignment.update_attributes(:user_id => params[:user_id],
                                 :computer_id => params[:computer_id],
                                 :assign_date => params[:assign_date])

      respond_to do |format|
        format.html { redirect_to assignments_url }
        format.json { head :no_content }
      end
    else
      #respond_to do |format|
        #format.html { redirect_to assignments_url }
        #format.json { head :no_content }
      #end
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
  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment }
    end
  end

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
end
