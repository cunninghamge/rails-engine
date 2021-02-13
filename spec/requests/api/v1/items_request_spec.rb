require 'rails_helper'

RSpec.describe "Items API" do
  describe 'items index' do
    it 'sends a list of 20 items' do
      create_list(:item, 21)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      check_hash_structure(items, :data, Array)
      expect(items[:data].count).to eq(20)
      expect(items[:data].pluck(:id).map(&:to_i)).to match_array(Item.first(20).pluck(:id))

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

    it 'sends an array of data even if one resource is found' do
      create(:item)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(1)
    end

    it 'sends an array of data even if zero resources are found' do
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(0)
    end

    describe 'allows for optional per_page query param' do
      it 'users can request less than the total number of items' do
        create_list(:item, 3)

        get '/api/v1/items?per_page=2'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(2)
        expect(items[:data].pluck(:id).map(&:to_i)).to match_array(Item.first(2).pluck(:id))
      end

      it 'users can request more than the total number of items' do
        create_list(:item, 2)

        get '/api/v1/items?per_page=3'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(2)
      end

      it 'returns an error if the user enters a negative number' do
        get '/api/v1/items?per_page=-2'

        expect(response.status).to eq(400)
      end
    end

    it 'allows for optional page query param' do
      create_list(:item, 21)

      get '/api/v1/items?page=1'

      expect(response).to be_successful

      page1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=2'

      page2 = JSON.parse(response.body, symbolize_names: true)

      expect(page1[:data].size).to eq(20)
      expect(page2[:data].size).to eq(1)
      expect(page1[:data].pluck(:id)).not_to include(page2[:data].pluck(:id))
    end

    it 'allows the user to pass both per_page and page query params' do
      create_list(:item, 5)

      get '/api/v1/items?per_page=3&page=2'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
      expect(items[:data].pluck(:id).map(&:to_i)).to eq(Item.last(2).pluck(:id))
    end

    describe 'fetches page 1 if user enters a page less than 1' do
      it 'if page is 0' do
        create_list(:item, 21)

        get '/api/v1/items?page=0'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        check_hash_structure(items, :data, Array)
        expect(items[:data].count).to eq(20)
        expect(items[:data].pluck(:id).map(&:to_i)).to match_array(Item.first(20).pluck(:id))
      end

      it 'if page is less than 1' do
        create_list(:item, 21)

        get '/api/v1/items?page=-2'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        check_hash_structure(items, :data, Array)
        expect(items[:data].count).to eq(20)
        expect(items[:data].pluck(:id).map(&:to_i)).to match_array(Item.first(20).pluck(:id))
      end
    end
  end

  describe 'get one item' do
    it 'returns a single record by id' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      check_hash_structure(item, :data, Hash)
      check_hash_structure(item[:data], :id, String)
      check_hash_structure(item[:data], :type, String)
      check_hash_structure(item[:data], :attributes, Hash)
      check_hash_structure(item[:data][:attributes], :name, String)
      check_hash_structure(item[:data][:attributes], :description, String)
      check_hash_structure(item[:data][:attributes], :unit_price, Float)
      check_hash_structure(item[:data][:attributes], :merchant_id, Integer)
      expect(item[:data].keys).to match_array(%i[id type attributes])
      expect(item[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end

    it 'returns a 404 if record does not exist' do
      get "/api/v1/items/1"

      expect(response.status).to eq(404)
    end

    it 'returns a 404 if a non-integer is entered' do
      get "/api/v1/items/one"

      expect(response.status).to eq(404)
    end
  end

  describe 'get a merchant by item id' do
    it 'gets the merchant of an item' do
      id = create(:item).id

      get "/api/v1/items/#{id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :data, Hash)
      check_hash_structure(merchant[:data], :id, String)
      check_hash_structure(merchant[:data], :type, String)
      check_hash_structure(merchant[:data], :attributes, Hash)
      check_hash_structure(merchant[:data][:attributes], :name, String)
      expect(merchant[:data].keys).to match_array(%i[id type attributes])
      expect(merchant[:data][:attributes].keys).to match_array(%i[name])
    end

    it 'returns a 404 if item is not found' do
      get "/api/v1/items/1/merchant"

      expect(response.status).to eq(404)

      get "/api/v1/items/one/merchant"

      expect(response.status).to eq(404)
    end
  end

  describe 'create an item' do
    it 'creates a new item' do
      merchant_id = create(:merchant).id
      item_params = attributes_for(:item).merge(merchant_id: merchant_id)
      headers = {'CONTENT_TYPE' => 'application/json'}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      check_hash_structure(item, :data, Hash)
      check_hash_structure(item[:data], :id, String)
      check_hash_structure(item[:data], :type, String)
      check_hash_structure(item[:data], :attributes, Hash)
      check_hash_structure(item[:data][:attributes], :name, String)
      check_hash_structure(item[:data][:attributes], :description, String)
      check_hash_structure(item[:data][:attributes], :unit_price, Float)
      check_hash_structure(item[:data][:attributes], :merchant_id, Integer)
      expect(item[:data].keys).to match_array(%i[id type attributes])
      expect(item[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end

    it 'returns an error if any attributes are missing' do
      merchant_id = create(:merchant).id
      item_params = attributes_for(:item).merge(merchant_id: merchant_id)
      missing_name = item_params.except(:name)
      missing_description = item_params.except(:description)
      missing_unit_price = item_params.except(:unit_price)
      missing_merchant_id = item_params.except(:merchant_id)
      headers = {'CONTENT_TYPE' => 'application/json'}
      param_sets = [missing_name, missing_description, missing_unit_price, missing_merchant_id]

      param_sets.each do |set|
        post '/api/v1/items', headers: headers, params: JSON.generate(item: set)

        expect(response.status).to eq(422)
      end
    end

    it 'ignores any additional attributes sent by the user' do
      merchant_id = create(:merchant).id
      item_params = attributes_for(:item).merge(merchant_id: merchant_id, model_number: '28P1817074')

      headers = {'CONTENT_TYPE' => 'application/json'}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      created_item = Item.last
      expect(created_item).not_to have_attribute(:model_number)

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end
  end

  describe 'updates' do
    it 'updates an exiting item' do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Hawaiian Shirt"}
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item = Item.find(id)
      expect(item.name).to eq(item_params[:name])
      expect(item.name).not_to eq(previous_name)


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to be_a(Hash)
      check_hash_structure(body, :data, Hash)
      check_hash_structure(body[:data], :id, String)
      check_hash_structure(body[:data], :type, String)
      check_hash_structure(body[:data], :attributes, Hash)
      check_hash_structure(body[:data][:attributes], :name, String)
      expect(body[:data][:attributes][:name]).to eq(item_params[:name])
      check_hash_structure(body[:data][:attributes], :description, String)
      check_hash_structure(body[:data][:attributes], :unit_price, Float)
      check_hash_structure(body[:data][:attributes], :merchant_id, Integer)
      expect(body[:data].keys).to match_array(%i[id type attributes])
      expect(body[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end

    it 'can update multiple attributes' do
      item = create(:item)
      previous_name = item.name
      previous_description = item.description
      previous_unit_price = item.unit_price
      previous_merchant_id = item.merchant_id
      new_merchant = create(:merchant)
      item_params = attributes_for(:item).merge(merchant_id: new_merchant.id)
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item = Item.find(item.id)
      expect(item.name).to eq(item_params[:name])
      expect(item.name).not_to eq(previous_name)
      expect(item.description).to eq(item_params[:description])
      expect(item.description).not_to eq(previous_description)
      expect(item.unit_price).to eq(item_params[:unit_price])
      expect(item.unit_price).not_to eq(previous_unit_price)
      expect(item.merchant_id).to eq(item_params[:merchant_id])
      expect(item.merchant_id).not_to eq(previous_merchant_id)
    end

    it 'returns an error for a bad item id' do
      item_params = attributes_for(:item)
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/1", headers: headers, params: JSON.generate(item: item_params)

      expect(response.status).to eq(404)
    end

    it 'returns an error for a bad merchant id' do
      item = create(:item)
      item_params = { merchant_id: item.merchant_id + 1}
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response.status).to eq(404)
    end

    it 'does not change the item if all attributes are missing' do
      item = create(:item)
      previous_name = item.name
      previous_description = item.description
      previous_unit_price = item.unit_price
      previous_merchant_id = item.merchant_id
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: {})

      expect(response).to be_successful

      item = Item.find(item.id)
      expect(item.name).to eq(previous_name)
      expect(item.description).to eq(previous_description)
      expect(item.unit_price).to eq(previous_unit_price)
      expect(item.merchant_id).to eq(previous_merchant_id)
    end

    it 'ignores any additional attributes sent by the user' do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: 'Hawaiian Shirt', model_number: '28P1817074' }
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item = Item.find(id)
      expect(item.name).to eq(item_params[:name])
      expect(item.name).not_to eq(previous_name)
      expect(created_item).not_to have_attribute(:model_number)

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end
  end

  describe 'delete an item' do
    it 'deletes an item and returns a 204 with no body' do
      id = create(:item).id

      expect{ delete "/api/v1/items/#{id}" }.to change(Item, :count).by(-1)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to be_empty
      expect{ Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'destroys an invoice if this was the only item on the invoice' do
      item = create(:item)
      invoice = create(:invoice, :with_items, items: [item])

      expect(Item.count).to eq(1)
      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect(Invoice.count).to eq(0)
      expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect{ Invoice.find(invoice.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
