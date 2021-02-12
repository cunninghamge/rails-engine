FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { "04/23" }
    result { [0, 1, 2].sample }
  end
end
