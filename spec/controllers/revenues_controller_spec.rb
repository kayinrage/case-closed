require 'rails_helper'

RSpec.describe RevenuesController do
  describe '#index' do
    it "uses 'RevenueForLast31Days' calculation" do
      get :index

      expect(RevenueForLast31Days).to have_received(:result)
    end
  end
end
