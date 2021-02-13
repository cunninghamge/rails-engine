class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.select_items(params[:per_page], params[:page])
    render json: ItemSerializer.format_items(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.format_item(item)
  end
end
