require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'class methods' do
    describe '.unshipped_orders' do
      before(:each) do
        11.times do |n|
          invoice = create(:invoice, status: 'packaged')
          create(:invoice_item, invoice: invoice, unit_price: 1.0, quantity: n + 1)
          create(:transaction, invoice: invoice, result: 'success')
        end
      end

      it 'selects a specified quantity of invoices ranked by potential revenue' do
        orders = Invoice.unshipped_orders(5)

        expect(orders.to_a.size).to eq(5)
        expect(orders[0].potential_revenue).to eq(11.0)
        expect(orders[1].potential_revenue).to eq(10.0)
        expect(orders[2].potential_revenue).to eq(9.0)
        expect(orders[3].potential_revenue).to eq(8.0)
        expect(orders[4].potential_revenue).to eq(7.0)
      end

      it 'returns 10 invoices if no quantity is specified' do
        orders = Invoice.unshipped_orders(nil)

        expect(orders.to_a.size).to eq(10)
      end
    end
  end
end
