require 'rails_helper'

RSpec.describe 'items search' do
  describe 'accepts a name query param' do
    it 'finds a collection of items matching the search term' do
      shirts = [create(:item, name: 'Shirt'), create(:item, name: 'T-shIrt')]
      pants = create(:item, name: 'pants')

      get "/api/v1/items/find_all?name=shirt"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(2)
      expect(items[:data].pluck(:id)).to match_array(shirts.pluck(:id).map(&:to_s))


      items[:data].each do |item|
        expect(item).to be_a(Hash)
        check_hash_structure(item, :id, String)
        check_hash_structure(item, :type, String)
        check_hash_structure(item, :attributes, Hash)
        check_hash_structure(item[:attributes], :name, String)
        check_hash_structure(item[:attributes], :description, String)
        check_hash_structure(item[:attributes], :unit_price, Float)
        check_hash_structure(item[:attributes], :merchant_id, Integer)
        expect(item.keys).to match_array(%i[id type attributes])
        expect(item[:attributes].keys).to match_array(%i[name description unit_price merchant_id])
      end
    end

    it 'searches both the name and description fields' do
      create(:item, name: "Pants")
      create(:item, description: "fancy pants")

      get "/api/v1/items/find_all?name=pant"

      expect(response.status).to eq(200)
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
    end

    it 'returns an empty array if no items are not found' do
      create(:item)

      get "/api/v1/items/find_all?name=NOMATCH"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data]).to be_empty
    end

    it 'returns a single item in an array if only one item is found' do
      item = create(:item, name: "Pants")

      get "/api/v1/items/find_all?name=pants"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(1)
    end
  end

  describe 'allows for optional price query params' do
    it 'accepts a min_price query' do
      included_items = create_list(:item, 2, unit_price: 5.00)
      excluded_item = create(:item, unit_price: 1.00)

      get "/api/v1/items/find_all?min_price=5.00"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(2)
      expect(items[:data].pluck(:id)).to match_array(included_items.pluck(:id).map(&:to_s))
    end

    it 'accepts a max_price query' do
      included_items = create_list(:item, 2, unit_price: 1.00)
      excluded_item = create(:item, unit_price: 5.00)

      get "/api/v1/items/find_all?max_price=4.99"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(2)
      expect(items[:data].pluck(:id)).to match_array(included_items.pluck(:id).map(&:to_s))
    end

    it 'accepts both min_price and max_price in the same request' do
      included_items = [create(:item, unit_price: 5.00), create(:item, unit_price: 9.00)]
      excluded_items = [create(:item, unit_price: 3.00), create(:item, unit_price: 10.00)]

      get "/api/v1/items/find_all?max_price=9.99&min_price=4.99"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(2)
      expect(items[:data].pluck(:id)).to match_array(included_items.pluck(:id).map(&:to_s))
    end
  end

  it 'returns an error if both text and price parameters are sent' do
    create_list(:item, 5)

    get "/api/v1/items/find_all?max_price=9.99&min_price=4.99&name=pants"

    expect(response.status).to eq(400)

    get "/api/v1/items/find_all?max_price=9.99&name=pants"

    expect(response.status).to eq(400)

    get "/api/v1/items/find_all?min_price=4.99&name=pants"

    expect(response.status).to eq(400)
  end

  it 'returns all items if neither a text or a price parameter are sent' do
    create_list(:item, 3)

    get '/api/v1/items/find_all'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].size).to eq(3)
  end
end
