class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  before_destroy :destroy_dependent_invoices, prepend: true

  def destroy_dependent_invoices
    invoices.unscope(:where)
            .group('invoices.id')
            .having("'{#{id}}' = (ARRAY_AGG(DISTINCT item_id))")
            .destroy_all
  end

  def self.find_all_by_text(name)
    where('LOWER(name) LIKE ?', "%#{name.downcase}%")
      .or(where('LOWER(description) LIKE ?', "%#{name.downcase}%"))
  end

  def self.find_all_by_price(min_price, max_price)
    where('unit_price BETWEEN ? AND ?', (min_price || 0), (max_price || Float::INFINITY))
  end

  def self.select_items_by_revenue(quantity)
    select('items.*, SUM(quantity * invoice_items.unit_price) AS revenue')
      .joins(invoices: :transactions)
      .where(transactions: { result: 'success' }, invoices: {status: 'shipped'} )
      .group(:id)
      .order('revenue' => :desc)
      .limit(quantity || 10)
  end
end
