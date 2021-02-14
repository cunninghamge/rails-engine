require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    describe '.select_records' do
      it 'gets the first 20 merchants by default' do
        create_list(:merchant, 21)

        selected = Merchant.select_records(nil, nil)
        expect(selected).to eq(Merchant.first(20))
      end

      it 'gets merchants when passed a page number' do
        create_list(:merchant, 21)

        selected = Merchant.select_records(nil, 2)
        expect(selected.count).to eq(1)
      end

      it 'gets merchants using a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_records(2, nil)
        expect(selected).to eq(Merchant.first(2))
      end

      it 'gets merchants using both a page number and a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_records(2, 2)
        expect(selected).to eq([Merchant.last])
      end
    end

    describe '.find_one' do
      it 'finds a merchant using a search term' do
        merchant = create(:merchant, name: "Ring World")
        create(:merchant, name: "Bob's Burgers")

        expect(Merchant.find_one('ring')).to eq(merchant)
      end

      it 'returns the first merchant in the database in case-sensitive alphabetical order if multiple matches are found' do
        turing = create(:merchant, name: "Turing")
        annies_rings = create(:merchant, name: "Annie's Rings")
        ring_world = create(:merchant, name: "ring world")

        expect(Merchant.find_one('ring')).to eq(annies_rings)
      end
    end
  end
end
