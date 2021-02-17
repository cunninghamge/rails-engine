class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.find_one(query)
    where('LOWER(name) LIKE ?', "%#{query.downcase}%").order(:name).first
  end

  def self.top_merchants(quantity)
    select('merchants.*, SUM(quantity * invoice_items.unit_price) revenue')
      .joins(items: { invoice_items: { invoice: :transactions } })
      .where(invoices: { status: :shipped }, transactions: { result: :success })
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity)
  end

  def self.select_by_item_sales(quantity)
    select('merchants.*, SUM(quantity) sales_count')
    .joins(items: { invoice_items: { invoice: :transactions } })
    .where(invoices: { status: :shipped }, transactions: { result: :success })
    .group(:id)
    .order(sales_count: :desc)
    .limit(quantity || 5)
  end
end
