require 'rails_helper'

describe Api::V1::BaseController, type: :controller do
  describe '#meta' do
    let(:object) { double('object', current_page: 1, next_page: 2, previous_page: nil, total_pages: 3, total_entries: 10) }

    it 'returns a hash of pagination metadata' do
      expect(subject.send(:meta, object)).to eq({
        current_page: 1,
        next_page: 2,
        prev_page: nil,
        total_pages: 3,
        total_count: 10
      })
    end
  end
end