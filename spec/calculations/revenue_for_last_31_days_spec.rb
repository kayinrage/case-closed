require 'rails_helper'

RSpec.describe RevenueForLast31Days do
  describe '.result' do
    it 'returns revenue for last 31 days' do
      create(:reservation, rates: { '2018-06-12' => 100 })
      create(:reservation, rates: { '2018-06-12' => 100 })
      create(:reservation, rates: { '2018-06-11' => 100 })
      create(:reservation, rates: { '2018-05-12' => 300 })

      travel_to('2018-06-12') do
        expect(RevenueForLast31Days.result).to eq(
          '2018-06-12' => 200,
          '2018-06-11' => 100,
          '2018-05-12' => 300,
        )
      end
    end

    it "doesn't return revenues older than 31 days" do
      create(:reservation, rates: { '2018-05-11' => 100 })

      travel_to('2018-06-12') do
        expect(RevenueForLast31Days.result).to eq({})
      end
    end

    it "doesn't return revenues from the future" do
      create(:reservation, rates: { '2018-06-13' => 100 })

      travel_to('2018-06-12') do
        expect(RevenueForLast31Days.result).to eq({})
      end
    end
  end
end
