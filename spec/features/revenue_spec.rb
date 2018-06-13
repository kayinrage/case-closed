require 'rails_helper'

RSpec.feature 'Revenue' do
  scenario 'user can see daily revenue for last 31 days' do
    create(:reservation, rates: { '2018-06-13' => 100 })
    create(:reservation, rates: { '2018-06-12' => 100 })
    create(:reservation, rates: { '2018-06-12' => 100 })
    create(:reservation, rates: { '2018-06-11' => 100 })
    create(:reservation, rates: { '2018-05-12' => 300 })
    create(:reservation, rates: { '2018-05-11' => 100 })

    travel_to(2018, 6, 12) do
      visit root_path
      click_on 'Revenue'

      expect(page).to have_content('Daily revenue for last 31 days')

      within('#revenue_table') do
        expect(page).to have_content('2018-06-12 200')
        expect(page).to have_content('2018-06-11 100')
        expect(page).to have_content('2018-05-12 300')
      end
    end
  end
end
