FactoryGirl.define do
  factory :project do
    name 'Test Project'
    description 'A description'
    cc '--cc--'
    staff_id '-staff_id--'
    budget 100.0
    start_date((Time.zone.now + 1.week).to_date)
    end_date((Time.zone.now + 2.week).to_date)
    approval :undecided
    img '--img--'

    trait :unapproved do
      approval :rejected
    end
  end
end
