require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'class methods' do
    describe '.select_records' do
      it 'gets the first 20 items by default' do
        create_list(:item, 21)

        selected = Item.select_records(nil, nil)
        expect(selected).to eq(Item.first(20))
      end

      it 'gets items when passed a page number' do
        create_list(:item, 21)

        selected = Item.select_records(nil, 2)
        expect(selected).to eq([Item.last])
      end

      it 'gets items using a per_page limit' do
        create_list(:item, 3)

        selected = Item.select_records(2, nil)
        expect(selected).to eq(Item.first(2))
      end

      it 'gets items using both a page number and a per_page limit' do
        create_list(:item, 3)

        selected = Item.select_records(2, 2)
        expect(selected).to eq([Item.last])
      end
    end

    describe '.find_all_by_text' do
      it 'finds a group of items using a search term' do
        included_items = [create(:item, name: "Car"),
                          create(:item, description: "Nascar flag")]
        excluded_item = create(:item, name: 'pants')

        expect(Item.find_all_by_text('car')).to match_array(included_items)
      end
    end

    describe '.find_all_by_price' do
      it 'finds a group of items by minimum price' do
        included_items = [create(:item, unit_price: 1.99),
                          create(:item, unit_price: 3.50)]
        excluded_item = create(:item, unit_price: 1.50)

        expect(Item.find_all_by_price(1.99, nil)).to match_array(included_items)
      end

      it 'finds a group of items by maximum price' do
        included_items = [create(:item, unit_price: 1.99),
                          create(:item, unit_price: 3.50)]
        excluded_item = create(:item, unit_price: 4.50)

        expect(Item.find_all_by_price(nil, 3.50)).to match_array(included_items)
      end

      it 'finds a group of items by minimum price and maximum price' do
        included_items = [create(:item, unit_price: 5.00), create(:item, unit_price: 9.00)]
        excluded_items = [create(:item, unit_price: 3.00), create(:item, unit_price: 10.00)]

        expect(Item.find_all_by_price(4.99, 9.99)).to match_array(included_items)
      end

      it 'finds no items if minimum price is greater than maximim price' do
        create_list(:item, 3)

        expect(Item.find_all_by_price(9.99, 4.99)).to match_array([])
      end

      it 'returns all items if no prices are passed' do
        create_list(:item, 3)

        expect(Item.find_all_by_price(nil, nil)).to match_array(Item.all)
      end
    end
  end

  describe 'instance methods' do
    describe '#destroy_dependent_invoices' do
      it 'deletes an invoice if it has no other items' do
        item = create(:item)
        invoices_to_delete = create_list(:invoice, 2, :with_items, items: [item])
        invoice_to_keep = create(:invoice, :with_items, items: [item, create(:item)])
        invoice_without_this_item = create(:invoice, :with_items, items: [create(:item)])

        item.destroy_dependent_invoices

        expect(item.invoices).to match_array([invoice_to_keep])
        expect(Invoice.find(invoice_to_keep.id)).to eq(invoice_to_keep)
        expect(Invoice.find(invoice_without_this_item.id)).to eq(invoice_without_this_item)
      end

      it 'deletes dependent invoices on deletion of the item' do
        item = create(:item)
        invoice_to_delete = create(:invoice, :with_items, items: [item])

        item.destroy

        expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect{ Invoice.find(invoice_to_delete.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
