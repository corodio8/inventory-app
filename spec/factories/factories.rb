
FactoryGirl.define do
#  sequence(:user_id_count, 1) do |n|
#    n
#  end

#  sequence :computer_id_count do |n|
#    n
#  end
  
  factory :user do
#    sequence(:id) { |n| n }
    id 1
    fname "John"
    lname "Smith"
    uname "jsmith"
    position "placeholder"
  end

  factory :computer do
#    sequence(:id, 1) { |n| n }
    id 1
    asset_tag "12345"
    computer_name "comp1"
    make "dell"
    model "E6400"
    serial_no "abc123"
  end

  factory :assignment do
    user_id ''
    computer_id ''
    assign_date '11-11-2008'
  end

  factory :associated_assignment, class: Assignment do
    association :user_id, factory: :user
    association :computer_id, factory: :computer
    assign_date '11-11-2008'
  end

  factory :dummy_assignment, class: Assignment do
  end

  factory :single_assignment, class: Assignment do
    user_id '1'
    computer_id '1'
    assign_date '11-11-2008'
  end

end
