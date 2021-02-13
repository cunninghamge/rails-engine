require 'rails_helper'

RSpec.describe "Merchants API" do
  describe 'merchants index' do
    it 'sends a list of 20 merchants' do
      create_list(:merchant, 21)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      check_hash_structure(merchants, :data, Array)
      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data].pluck(:id).map(&:to_i)).to match_array(Merchant.first(20).pluck(:id))

      merchants[:data].each do |merchant|
        expect(merchant).to be_a(Hash)
        check_hash_structure(merchant, :id, String)
        check_hash_structure(merchant, :type, String)
        check_hash_structure(merchant, :attributes, Hash)
        check_hash_structure(merchant[:attributes], :name, String)
        expect(merchant.keys).to match_array(%i[id type attributes])
        expect(merchant[:attributes].keys).to match_array(%i[name])
      end
    end

    it 'sends an array of data even if one resource is found' do
      create(:merchant)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(1)
    end

    it 'sends an array of data even if zero resources are found' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(0)
    end

    describe 'allows for optional per_page query param' do
      it 'users can request less than the total number of merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants?per_page=2'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(2)
        expect(merchants[:data].pluck(:id).map(&:to_i)).to match_array(Merchant.first(2).pluck(:id))
      end

      it 'users can request more than the total number of merchants' do
        create_list(:merchant, 2)

        get '/api/v1/merchants?per_page=3'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(2)
      end

      it 'returns an error if the user enters a negative number' do
        get '/api/v1/merchants?per_page=-2'

        expect(response.status).to eq(400)
      end
    end

    it 'allows for optional page query param' do
      create_list(:merchant, 21)

      get '/api/v1/merchants?page=1'

      expect(response).to be_successful

      page1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=2'

      page2 = JSON.parse(response.body, symbolize_names: true)

      expect(page1[:data].size).to eq(20)
      expect(page2[:data].size).to eq(1)
      expect(page1[:data].pluck(:id)).not_to include(page2[:data].pluck(:id))
    end

    it 'allows the user to pass both per_page and page query params' do
      create_list(:merchant, 5)

      get '/api/v1/merchants?per_page=3&page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)
      expect(merchants[:data].pluck(:id).map(&:to_i)).to eq(Merchant.last(2).pluck(:id))
    end

    describe 'fetches page 1 if user enters a page less than 1' do
      it 'if page is 0' do
        create_list(:merchant, 21)

        get '/api/v1/merchants?page=0'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        check_hash_structure(merchants, :data, Array)
        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data].pluck(:id).map(&:to_i)).to match_array(Merchant.first(20).pluck(:id))
      end

      it 'if page is less than 1' do
        create_list(:merchant, 21)

        get '/api/v1/merchants?page=-2'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        check_hash_structure(merchants, :data, Array)
        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data].pluck(:id).map(&:to_i)).to match_array(Merchant.first(20).pluck(:id))
      end
    end
  end

  describe 'get one merchant' do
    it 'returns a single record by id' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

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

    it 'returns a 404 if record does not exist' do
      get "/api/v1/merchants/1"

      expect(response.status).to eq(404)
    end
  end
end
