require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }

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
