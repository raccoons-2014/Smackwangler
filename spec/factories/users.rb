FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name(4..40) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    # factory :invalid_user do
    #   username nil
    #   email { "murokwuzhere.com" }
    #   password nil
    # end
  end
end
