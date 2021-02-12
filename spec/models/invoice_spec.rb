require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values([:packaged, :shipped, :returned])}
  end
end
