FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { [:packaged, :shipped, :returned].sample }

    trait :with_items do
      transient { items { create_list(:item, 2) } }
      after(:create) do |invoice, evaluator|
        evaluator.items.each do |item|
          create(:invoice_item, invoice: invoice, item: item)
        end
      end
    end
  end
end
