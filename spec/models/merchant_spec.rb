require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'class methods' do
    describe '.select_merchants' do
      it 'gets the first 20 merchants by default' do
        create_list(:merchant, 21)

        selected = Merchant.select_merchants(nil, nil)
        expect(selected).to eq(Merchant.first(20))
      end

      it 'gets merchants when passed a page number' do
        create_list(:merchant, 21)

        selected = Merchant.select_merchants(nil, 2)
        expect(selected).to eq([Merchant.last])
      end

      it 'gets merchants using a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_merchants(2, nil)
        expect(selected).to eq(Merchant.first(2))
      end

      it 'gets merchants using both a page number and a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_merchants(2, 2)
        expect(selected).to eq([Merchant.last])
      end
    end
  end
end
