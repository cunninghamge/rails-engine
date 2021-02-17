class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.total_revenue_by_date(start, end_date)
    joins(invoice: :transactions)
      .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
      .where(invoices: { created_at: Date.parse(start)..Date.parse(end_date).end_of_day })
      .sum('quantity * unit_price')
  end

  def self.total_revenue
    joins(invoice: :transactions)
      .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
      .sum('quantity * invoice_items.unit_price')
  end
end
