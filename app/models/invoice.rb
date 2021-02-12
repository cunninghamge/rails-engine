class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  enum status: { packaged: 0, shipped: 1, returned: 2 }
end
