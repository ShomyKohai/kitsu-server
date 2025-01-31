# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListImport::Anilist do
  subject do
    described_class.create(
      input_text: 'toyhammered',
      user: build(:user)
    )
  end

  before do
    stub_request(:post, 'https://graphql.anilist.co')
      .to_return(body: fixture('list_import/anilist/toyhammered_full_list.json'))
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:input_text) }

    it {
      is_expected.to validate_length_of(:input_text)
        .is_at_least(3)
        .is_at_most(20)
    }
  end

  describe '#count' do
    it 'returns the total number of entries (combined)' do
      expect(subject.count).to eq(12)
    end
  end

  describe '#each' do
    let(:row_double) { instance_double(ListImport::Anilist::Row) }

    it 'yields 12 times' do
      expect(ListImport::Anilist::Row).to receive(:new).at_least(:once) { row_double }
      expect(row_double).to receive(:media).at_least(:once)
      expect(row_double).to receive(:data).at_least(:once)

      expect { |b|
        subject.each(&b)
      }.to yield_control.exactly(12)
    end
  end
end
