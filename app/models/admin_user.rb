class AdminUser < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :email, :password, :password_confirmation

  validates :email, :uniqueness => true

  def create_default_admin
    if !(AdminUser.find_by_email("admin"))
      AdminUser.new({
        email => 'admin',
        password => 'admin',
        password_confirmation => 'admin'
      }).save_with_validation(false)
    end
  end
end
