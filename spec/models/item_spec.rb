require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }

  describe 'class methods' do
    describe '.select_items' do
      it 'gets the first 20 items by default' do
        create_list(:item, 21)

        selected = Item.select_items(nil, nil)
        expect(selected).to eq(Item.first(20))
      end

      it 'gets items when passed a page number' do
        create_list(:item, 21)

        selected = Item.select_items(nil, 2)
        expect(selected).to eq([Item.last])
      end

      it 'gets items using a per_page limit' do
        create_list(:item, 3)

        selected = Item.select_items(2, nil)
        expect(selected).to eq(Item.first(2))
      end

      it 'gets items using both a page number and a per_page limit' do
        create_list(:item, 3)

        selected = Item.select_items(2, 2)
        expect(selected).to eq([Item.last])
      end
    end
  end
end
