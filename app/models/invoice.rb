class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  enum status: [:packaged, :shipped, :returned]
end
