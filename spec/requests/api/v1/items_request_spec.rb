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
  end
end
