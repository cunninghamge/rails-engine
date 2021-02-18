Transaction.destroy_all
InvoiceItem.destroy_all
Item.destroy_all
Invoice.destroy_all
Customer.destroy_all
Merchant.destroy_all


100.times do
  merchant = FactoryBot.create(:merchant)
  FactoryBot.create_list(:item, rand(2..30), merchant: merchant)
end

FactoryBot.create_list(:customer, 200)

#in progress orders with successful transaction, status packaged
200.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(1..10).days.ago, status: :packaged)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :success)
end

#in progress orders with multiple transactions, status packaged
20.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(1..30).days.ago, status: :packaged)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :failed)
  FactoryBot.create(:transaction, invoice: invoice, result: :success)
end

#in progress orders with failed transaction, status packaged
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(1..30).days.ago, status: :packaged)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :failed)
end

#completed orders
1000.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(2..364).days.ago, status: :shipped)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :success)
end

#completed orders w/ multiple transactions
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(2..364).days.ago, status: :shipped)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :failed)
  FactoryBot.create(:transaction, invoice: invoice, result: :success)
end

#cancelled orders
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, merchant: Merchant.order('random()').first, created_at: rand(2..364).days.ago, status: :returned)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: :failed)
end
