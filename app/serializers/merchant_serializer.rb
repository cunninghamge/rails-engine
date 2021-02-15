class MerchantSerializer
  def self.format_merchants(merchants)
    { data: merchants.map { |merchant| merchant_hash(merchant) } }
  end

  def self.format_merchant(merchant)
    { data: merchant_hash(merchant) }
  end

  def self.format_merchants_by_revenue(merchants)
    { data: merchants.map do |merchant|
      merchant_hash(merchant, 'merchant_name_revenue', { revenue: merchant.revenue })
    end }
  end

  def self.merchant_hash(merchant, type = 'merchant', addl_attrs = {})
    if merchant
      { id: merchant.id.to_s,
        type: type,
        attributes: {
          name: merchant.name
        }.merge(addl_attrs) }
    else
      {}
    end
  end
end
