class Api::V1::RevenueController < ApplicationController
  def revenue
    if params[:start] > params[:end]
      render_invalid_parameters
    else
      revenue = InvoiceItem.total_revenue_by_date(params[:start], params[:end])
      render json: RevenueSerializer.revenue_by_date(revenue)
    end
  end

  def items
    items = Item.select_items_by_revenue(params[:quantity])
    render json: ItemSerializer.format_items_by_revenue(items)
  end

  def unshipped
    orders = Invoice.unshipped_orders(params[:quantity])
    render json: RevenueSerializer.unshipped_orders(orders)
  end

  def weekly
    totals = Invoice.weekly_revenue
    render json: RevenueSerializer.weekly_revenue(totals)
  end

  def merchants
    if params[:quantity]
      merchants = Merchant.top_merchants(params[:quantity])
      render json: MerchantSerializer.format_merchants_by_revenue(merchants)
    else
      render_invalid_parameters
    end
  end
end
