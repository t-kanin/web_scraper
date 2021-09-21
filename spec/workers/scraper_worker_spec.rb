# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ScraperWorker, type: :worker do
  describe 'worker' do
    context 'when perform' do
      subject { described_class }

      it { is_expected.to be_processed_in :default }

      it 'enques job to the jobs array' do
        subject.perform_async(%w[man cracker])
        expect(subject).to have_enqueued_sidekiq_job(%w[man cracker])
      end
    end
  end
end
