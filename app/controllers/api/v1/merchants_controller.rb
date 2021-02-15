class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.select_records(params[:per_page], params[:page])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = if params[:item_id]
                 Item.find(params[:item_id]).merchant
               else
                 Merchant.find(params[:id])
               end
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = Merchant.find_one(params[:name]) if params[:name]
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { data: {} }
    end
  end
end
