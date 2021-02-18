require 'rails_helper'

RSpec.describe 'Index page' do
  it 'should have a section for each endpoint' do
    visit root_path

    expect(page).to have_content("Sales Engine")
    endpoints = [ "/api/v1/merchants",
                  "/api/v1/merchants/:id",
                  "/api/v1/merchants/find",
                  "/api/v1/merchants/find_all",
                  "/api/v1/merchants/:merchant_id/items",
                  "/api/v1/items",
                  "/api/v1/items/:id",
                  "/api/v1/items/find",
                  "/api/v1/items/find_all",
                  "/api/v1/items",
                  "/api/v1/items/:id",
                  "/api/v1/items/:id",
                  "/api/v1/items/:item_id/merchant",
                  "/api/v1/revenue/merchants",
                  "/api/v1/merchants/most_items",
                  "/api/v1/revenue/merchants/:id",
                  "/api/v1/revenue/items",
                  "/api/v1/revenue/unshipped",
                  "/api/v1/revenue",
                  "/api/v1/revenue/weekly"
                ]

    endpoints.each do |endpoint|
      expect(page).to have_content(endpoint)
    end
  end
end
