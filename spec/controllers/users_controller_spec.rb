# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    subject do
      post :create, params: {
        email: user.email,
        password: user.password,
        password_confirmation: user.password
      }
    end

    let(:user) { build :user }

    context 'resgister with invalid input' do
      it 'renders new' do
        subject { post :create, params: {} }
        expect(response).to render_template(:new)
      end
    end

    context 'register with valid input' do
      it 'registers then redirect to index' do
        expect { subject }.to change(User, :count).by 1
        expect(response).to have_http_status(:found)
      end
    end
  end
end
