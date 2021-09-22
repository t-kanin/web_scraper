# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScraperService, type: :service do
  describe 'call' do
    subject do
      VCR.use_cassette('google') do
        uri = URI('https://www.google.com/search?q=ads')
        Net::HTTP.get(uri)
      end
    end

    let(:res) { described_class.instance.result }

    context 'fetch page_result' do
      it 'returns 2,370... results' do
        allow(@driver).to receive(:page_source).and_return(subject)
        expect(res[:page_result]).to match 'ผลการค้นหาประมาณ 2,370,000,000 รายการ'
      end
    end

    context 'fetch ad_words_results' do
      it 'returns with title and url' do
        mock =
          [
            {
              title: 'Google Ads Thailand | ค้นพบคีย์เวิร์ดที่เหมาะสม',
              url: 'https://ads.google.com/intl/th_th/getstarted/'
            }
          ]

        allow(@driver).to receive(:page_source).and_return(subject)
        expect(res[:ad_result]).to eq(mock)
      end
    end

    context 'fetch non_ad_words_results' do
      it 'returns with title and url' do
        mock =
          [
            {
              title: 'สร้างบัญชี Google Ads: วิธีลงชื่อสมัครใช้',
              url: 'https://support.google.com/google-ads/answer/6366720?hl=th'
            },
            {
              title: 'Google Ads - ลงชื่อเข้าใช้',
              url: 'https://www.google.com/partners/signup?hl=th'
            },
            {
              title: 'Google Ads - แอปพลิเคชันใน Google Play',
              url: 'https://play.google.com/store/apps/details?id=com.google.android.apps.adwords&hl=th&gl=US'
            }
          ]
        allow(@driver).to receive(:page_source).and_return(subject)
        expect(res[:search_result]).to include(mock)
      end
    end

    context 'store result' do
      let(:instance) { described_class.instance }
      let(:k) { create :keyword, :ads }

      it 'inserts to the database' do
        allow(@driver).to receive(:page_source).and_return(subject)
        expect { instance.store_result(k.keyword, instance.result) }
          .to  change(AdResult, :count).by(1)
          .and change(SearchResult, :count).by 10
      end
    end
  end
end
