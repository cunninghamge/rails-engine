class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.find_one(query)
    where('LOWER(name) LIKE ?', "%#{query.downcase}%").order(:name).first
  end

  def self.top_merchants(quantity)
    select('merchants.*, SUM(quantity * invoice_items.unit_price) revenue')
      .joins(items: [invoice_items: [invoice: :transactions]])
      .where(invoices: { status: 'shipped' }, transactions: { result: 'success' })
      .group(:id)
      .order('revenue' => :desc)
      .limit(quantity)
  end
end
