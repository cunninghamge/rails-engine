FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { [:packaged, :shipped, :returned].sample }
  end
end
