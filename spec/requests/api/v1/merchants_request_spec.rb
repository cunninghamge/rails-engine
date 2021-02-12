require 'rails_helper'

RSpec.describe "Merchants API" do
  describe 'merchants index' do
    it 'sends a list of 20 merchants' do
      create_list(:merchant, 21)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        check_structure(merchant, :id, Integer)
        check_structure(merchant, :name, String)
        expect(merchant.keys).to match_array(%i[id name])
      end
    end

    it 'sends an array of data even if one resource is found'
    it 'sends an array of data even if zero resources are found'
    it 'allows for optional per_page query param'
    it 'allows for optional page query param'
    it 'page query param defaults to 1 if not specified by the user'
    it 'allows the user to pass both per_page and page query params'
  end
end
