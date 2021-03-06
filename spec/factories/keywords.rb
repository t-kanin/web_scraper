# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    sequence(:keyword) { Faker::Superhero.prefix }
    association :user

    trait :ads do
      keyword { 'ads' }
    end
  end
end
