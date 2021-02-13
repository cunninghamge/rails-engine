class ItemSerializer
  def self.format_items(items)
    { data: items.map { |item| item_hash(item) } }
  end

  def self.format_item(item)
    { data: item_hash(item) }
  end

  def self.item_hash(item)
    { id: item.id.to_s,
      type: 'item',
      attributes: {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price,
        merchant_id: item.merchant_id
      } }
  end
end
