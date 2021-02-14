class Api::V1::RevenueController < ApplicationController
  def revenue
    if params[:start] > params[:end]
      render_invalid_parameters
    else
      revenue = InvoiceItem.total_revenue_by_date(params[:start], params[:end])
      render json: RevenueSerializer.revenue_by_date(revenue)
    end
  end
end
