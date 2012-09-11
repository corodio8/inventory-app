class Computer < ActiveRecord::Base
  attr_accessible :asset_tag, :computer_name, :make, :model, :serial_no

  validates :asset_tag, :computer_name, :make, :model, :serial_no, :presence => true
  
  has_many :assignments, :foreign_key => 'computer_id'
  has_many :users, :through => :assignments
end
