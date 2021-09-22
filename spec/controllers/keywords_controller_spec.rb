# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  describe 'GET /index' do
    subject { get :index }

    let(:user) { create :user }

    context 'when user not sign in' do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when user sign in' do
      before { sign_in user }

      it { is_expected.to render_template(:index) }

      it 'returns correct keywords' do
        subject
        aggregate_failures do
          expect(assigns(:keywords)).to be_empty
          arr = create_list(:keyword, 3, user: user)
          expect(assigns(:keywords)).to eq arr
        end
      end
    end
  end

  describe 'POST #import' do
    subject { post :import, params: { file: file } }

    let(:user) { create :user }
    let(:file) { fixture_file_upload(file_fixture('demo.csv')) }

    context 'when user not sign in' do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when uer sign in' do
      let(:file2) { fixture_file_upload(file_fixture('demo.txt')) }

      before { sign_in user }

      it 'upload empty file' do
        post :import, params: { file: nil }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('Please select file to upload')
      end

      it 'missing headers' do
        FileHandlerHelper.generate_csv([], [])
        expect(subject).to redirect_to(root_path)
        expect(flash[:alert]).to match('Missing require headers')
      end

      it 'has invalid csv extension' do
        allow(File).to receive(:extname).and_return('.txt')
        expect(subject).to redirect_to(root_path)
        expect(flash[:alert]).to match('FileHandler::FileExntensionError')
      end

      it 'has valid csv file' do
        FileHandlerHelper.generate_csv(%w[a b c d e k], %w[keyword])
        expect(subject).to redirect_to(root_path)
        expect(flash[:notice]).to match('Successfully imported data.')
      end
    end
  end
end
