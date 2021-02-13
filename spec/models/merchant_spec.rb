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
        expect(selected).to eq([Merchant.last])
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
  end
end
