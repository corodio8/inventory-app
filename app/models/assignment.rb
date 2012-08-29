class Assignment < ActiveRecord::Base
  attr_accessible :assign_date, :computer_id, :user_id

  belongs_to :user
  belongs_to :computer

end
