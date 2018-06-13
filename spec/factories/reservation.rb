FactoryBot.define do
  factory :reservation do
    sequence(:reservation_id) { |n| n.to_s }
    checkin_date { Date.current }
    checkout_date { 2.days.from_now }
    guest_name 'Steve Rogers'
    sequence(:room_id) { |n| "887-06-#{n}" }
    rates {
      {
        Date.current.to_s           => 100,
        (Date.current + 1.day).to_s => 200
      }
    }
    total 300
  end
end
