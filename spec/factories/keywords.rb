# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    sequence(:keyword) { |n| Faker::Superhero.prefix }
    association :user
  end
end
