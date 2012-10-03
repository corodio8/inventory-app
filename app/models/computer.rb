class Computer < ActiveRecord::Base
  attr_accessible :asset_tag, :computer_name, :make, :model, :serial_no

  validates :asset_tag, :computer_name, :make, :model, :serial_no, :presence => true
  validates :asset_tag, :uniqueness => { :scope => :serial_no, :message => "in the event that an asset tag is reused, it cannot have the same serial_no" }

  has_many :assignments, :foreign_key => 'computer_id', :dependent => :destroy
  has_many :users, :through => :assignments
end
