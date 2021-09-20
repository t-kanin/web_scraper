# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'when first created' do
    subject { build :keyword }
    it { is_expected.to be_valid }
  end

  describe '.associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:search_result) }
    it { is_expected.to have_many(:ad_result) }
  end
end
