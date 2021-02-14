class Api::V1::ItemsController < ApplicationController
  def index
    items = if params[:merchant_id]
              Merchant.find(params[:merchant_id]).items
            else
              Item.select_records(params[:per_page], params[:page])
            end
    render json: ItemSerializer.format_items(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.format_item(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.format_item(item), status: :created
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.format_item(item)
  end

  def destroy
    Item.find(params[:id]).destroy
  end

  def find_all
    items = if params[:name].present? && !(params[:min_price] || params[:max_price])
              Item.find_all_by_text(params[:name])
            elsif !params[:name]
              Item.find_all_by_price(params[:min_price], params[:max_price])
            elsif params[:name].blank?
              []
            end
    render json: ItemSerializer.format_items(items)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
