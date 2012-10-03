
class ComputersController < ApplicationController
  
  def index
    @computers = Computer.order("asset_tag ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @computers }
    end
  end

  def show
    @computer = Computer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @computer }
    end
  end

  def new
    @computer = Computer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @computer }
    end
  end

  def edit
    @computer = Computer.find(params[:id])
  end

  def create
    @computer = Computer.new(params[:computer])

    respond_to do |format|
      if @computer.save
        #Checks if default user exists, if not, then create
        default_user = User.where(:uname => User.get_default).first_or_create(:fname => 'IT', :lname => 'Dept')
        params = {
            :user_id => default_user.id,
            :computer_id => @computer.id,
            :assign_date => Date.today
        }
        
        create_assignment(params)

        format.html { redirect_to @computer, notice: 'Computer was successfully created.' }
        format.json { render json: @computer, status: :created, location: @computer }
      else
        format.html { render action: "new" }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @computer = Computer.find(params[:id])

    respond_to do |format|
      if @computer.update_attributes(params[:computer])
        format.html { redirect_to @computer, notice: 'Computer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @computer = Computer.find(params[:id])
    @computer.destroy

    respond_to do |format|
      format.html { redirect_to computers_url }
      format.json { head :no_content }
    end
  end

  def assign_to
    @users = User.all
    @computer = Computer.find(params[:id])
    @computer_id = params[:id]

    respond_to do |format|
      format.html
      format.json
    end
  end
end
