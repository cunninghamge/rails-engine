require 'rails_helper'

RSpec.describe ErrorSerializer do
  it 'invalid parameters' do
    error = ErrorSerializer.invalid_parameters

    expect(error).to be_a(Hash)
    check_hash_structure(error, :message, String)
    check_hash_structure(error, :errors, Array)
    expect(error[:errors][0]).to eq("invalid request parameters")
  end

  it 'invalid parameters' do
    error = ErrorSerializer.invalid_parameters

    expect(error).to be_a(Hash)
    check_hash_structure(error, :message, String)
    check_hash_structure(error, :errors, Array)
    expect(error[:errors][0]).to be_a(String)
  end
end
