require 'test_helper'

class UserTest < ActiveSupport::TestCase
   test "fail with empty fields" do
     user = User.new
     assert user.invalid?
     assert user.errors[:fname].any?
     assert user.errors[:lname].any?
     assert user.errors[:position].any?
     assert user.errors[:uname].any?
   end
end
