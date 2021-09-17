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
end
