class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.select_merchants(params[:per_page], params[:page])
    render json: MerchantSerializer.format_merchants(merchants)
  end
end
