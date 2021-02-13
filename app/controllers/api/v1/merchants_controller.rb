class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.select_records(params[:per_page], params[:page])
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    merchant = if params[:item_id]
                 Item.find(params[:item_id]).merchant
               else
                 Merchant.find(params[:id])
               end
    render json: MerchantSerializer.format_merchant(merchant)
  end

  def find
    merchant = Merchant.find_one(params[:name])
    render json: MerchantSerializer.format_merchant(merchant)
  end
end
