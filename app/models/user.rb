class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :position, :uname

  validates :fname, :lname, :uname, :presence => true

  has_many :assignments
  has_many :computers, :through => :assignments

  #When any asset is created it is automatically assigned to the use with this uname
  #If that uname does not exist, then it will be created.
  #This will serve as an "Acquire Date" for records
  @@default_uname = 'IT'
  
  #returns default uname
  def self.get_default
    default_uname = @@default_uname
  end

end
