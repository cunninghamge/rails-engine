FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { "" }
    credit_card_expiration_date { "2021-02-11" }
    result { 1 }
  end
end
