class MerchantSerializer
  def self.format_merchants(merchants)
    { data: merchants.map { |merchant| merchant_hash(merchant) } }
  end

  def self.format_merchant(merchant)
    { data: merchant_hash(merchant) }
  end

  def self.merchant_hash(merchant)
    if merchant
      { id: merchant.id.to_s,
        type: 'merchant',
        attributes: {
          name: merchant.name
        } }
      else
        {}
      end
  end
end
