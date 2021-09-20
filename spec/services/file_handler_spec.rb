# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe FileHandler, type: :model do
  describe '.import' do
    subject { described_class.handle_upload(file, user.id) }

    let(:user) { create :user }
    
    context 'when have empty csv' do
      let(:file) { nil }
      it 'raises FileEmptyError' do
        expect { subject }.to raise_error(FileHandler::FileEmptyError, 'Please select file to upload')
      end
    end

    context 'when have invalid file extension' do
      let(:file) { fixture_file_upload(file_fixture('demo.txt')) }
      it 'raises FileExntensionError' do
        expect { subject }.to raise_error(FileHandler::FileExntensionError)
      end
    end
  end
end
