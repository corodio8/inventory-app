class Assignment < ActiveRecord::Base
  attr_accessible :assign_date

  validates :assign_date, :uniqueness => { :scope => :computer_id,
    :message => "computers should not be assigned more than once a day, please change date or remove previous record" }

  belongs_to :user
  belongs_to :computer

end
