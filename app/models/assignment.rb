class Assignment < ActiveRecord::Base
  attr_accessible :assign_date, :computer_id, :user_id

  belongs_to :user
  belongs_to :computer, :class_name => 'Computer', :foreign_key => 'computer_id'

end
