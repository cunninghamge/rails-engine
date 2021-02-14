class RevenueSerializer
  class << self
    def revenue_by_date(revenue)
      { data: { id: nil,
                type: 'revenue',
                attributes: {
                  revenue: revenue
                } } }
    end

    def unshipped_orders(orders)
      { data: orders.map do |order|
        { id: order.id.to_s,
          type: 'unshipped_order',
          attributes: {
            potential_revenue: order.potential_revenue
          } }
        end
      }
    end
  end
end
