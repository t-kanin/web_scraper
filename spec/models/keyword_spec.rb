# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'when first created' do
    subject { build :keyword }
    it { is_expected.to be_valid }
  end

  defscribe '#validations' do
    it { is_expected.to validate_presence_of(:keyword) }
  end

  describe '.associations' do
    it { is_expected.to belong_to(:user) }
  end
end
