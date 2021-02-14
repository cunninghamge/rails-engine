class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.find_one(query)
    where('LOWER(name) LIKE ?', "%#{query.downcase}%").order(:name).first
  end
end
