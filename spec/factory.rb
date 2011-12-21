# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
  factory :user do
    username              "mhartl"
    firstname 					  "Michael"
    lastname              "Hartl"
    email					        "mhartl@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end
