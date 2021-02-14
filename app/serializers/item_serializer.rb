class ItemSerializer
  def self.format_items(items)
    { data: items.map { |item| item_hash(item) } }
  end

  def self.format_item(item)
    { data: item_hash(item) }
  end

  def self.format_items_by_revenue(items)
    { data: items.map { |item| item_hash(item, 'item_revenue', {revenue: item.revenue}) } }
  end

  def self.item_hash(item, type = 'item', addl_attrs = {})
    { id: item.id.to_s,
      type: type,
      attributes: {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price,
        merchant_id: item.merchant_id
      }.merge(addl_attrs) }
  end
end
