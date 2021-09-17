FactoryBot.define do
  factory :keyword do
    keyword { Faker::Superhero.prefix }

    association :user
  end
end
