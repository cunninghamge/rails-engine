FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { [0, 1, 2].sample }
  end
end
