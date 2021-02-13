require 'rails_helper'

RSpec.describe 'merchant search' do
  it 'returns a single merchant' do
    create(:merchant, name: "Ring World")

    get "/api/v1/merchants/find_one?text=ring"

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

  it 'returns an empty Hash if no merchant is not found' do
    create(:merchant)

    get "/api/v1/merchants/find_one?text=NOMATCH"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    check_hash_structure(merchant, :data, Hash)
    expect(merchant[:data]).to be_empty
  end

  it 'returns an error if no query string is provided' do
    get "/api/v1/merchants/find_one"

    expect(response.status).to eq(400)
  end

  it 'returns the first merchant in the database in case-sensitive alphabetical order if multiple matches are found' do
    turing = create(:merchant, name: "Turing")
    ring_world = create(:merchant, name: "Ring World")

    get "/api/v1/merchants/find_one?text=ring"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:id]).to eq(ring_world.to_s)
  end
end
