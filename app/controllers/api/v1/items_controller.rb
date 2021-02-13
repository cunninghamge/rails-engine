class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.select_items(params[:per_page], params[:page])
    render json: ItemSerializer.format_items(items)
  end
end
