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
    error = ErrorSerializer.record_not_found("Couldn't find Item with 'id'=1")

    expect(error).to be_a(Hash)
    check_hash_structure(error, :message, String)
    check_hash_structure(error, :errors, Array)
    expect(error[:errors][0]).to be_a(String)
  end

  it 'record invalid' do
    error = ErrorSerializer.record_invalid("Validation failed: Name can't be blank")

    expect(error).to be_a(Hash)
    check_hash_structure(error, :message, String)
    check_hash_structure(error, :errors, Array)
    expect(error[:errors][0]).to be_a(String)
  end
end
