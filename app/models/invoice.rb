class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  def self.unshipped_orders(quantity)
    select('invoices.*, SUM(quantity * unit_price) AS potential_revenue')
      .joins(:invoice_items, :transactions)
      .where(status: 'packaged', transactions: { result: 'success' })
      .group(:id)
      .order('potential_revenue' => :desc)
      .limit(quantity || 10)
  end

  def self.weekly_revenue
    select("DATE_TRUNC('week', invoices.created_at) week, SUM(quantity * unit_price) revenue")
      .joins(:invoice_items, :transactions)
      .where(status: 'shipped', transactions: {result: 'success'})
      .group('week')
      .order('week')
  end
end
