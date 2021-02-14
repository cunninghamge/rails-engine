require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'class methods' do
    it '.total_revenue' do
    #   #complete invoices have a transaction that is successful unless specified otherwise and a revenue of 1.00
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-09')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-10')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-11')

      create(:complete_invoice, status: 'shipped', created_at: '2012-03-08')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-12')
      create(:complete_invoice, status: 'returned', created_at: '2012-03-10')
      create(:complete_invoice, status: 'packaged', created_at: '2012-03-10')
      create(:complete_invoice, result: 'refunded', status: 'shipped', created_at: '2012-03-10')
      create(:complete_invoice, result: 'failed', status: 'shipped', created_at: '2012-03-10')

      expect(InvoiceItems.total_revenue).to eq(3.0)
    end
  end
end
