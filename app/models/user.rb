class User < ActiveRecord::Base
    attr_accessible :fname, :lname, :position, :uname

    validates :fname, :lname, :position, :uname, :presence => true

    has_many :assignments
end
