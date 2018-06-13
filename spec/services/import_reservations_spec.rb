require 'rails_helper'

RSpec.describe ImportReservations do
  describe '.call' do
    it 'saves all reservation to database' do
      allow(ServiceX::Client).to receive(:get_all_reservations).and_return(
        [
          {
            'reservationID' => '01234',
            'checkinDate'   => '2018-06-11',
            'checkoutDate'  => '2018-06-16',
            'guestName'     => 'Tony Stark',
            'roomID'        => '887-06-16'
          },
          {
            'reservationID' => '01235',
            'checkinDate'   => '2018-06-12',
            'checkoutDate'  => '2018-06-17',
            'guestName'     => 'Steve Rogers',
            'roomID'        => '887-06-17'
          }
        ]
      )
      allow(ServiceX::Client).to receive(:get_reservation).with('01234').and_return(
        {
          'reservationID' => '01234',
          'checkinDate'   => '2018-06-11',
          'checkoutDate'  => '2018-06-16',
          'guestName'     => 'Tony Stark',
          'roomID'        => '887-06-16',
          'rates'         => {
            '2018-06-11' => 100,
            '2018-06-12' => 200,
            '2018-06-13' => 250,
            '2018-06-14' => 250,
            '2018-06-15' => 100,
          },
          'total'         => 900
        }
      )
      allow(ServiceX::Client).to receive(:get_reservation).with('01235').and_return(
        {
          'reservationID' => '01235',
          'checkinDate'   => '2018-06-12',
          'checkoutDate'  => '2018-06-17',
          'guestName'     => 'Steve Rogers',
          'roomID'        => '887-06-17',
          'rates'         => {
            '2018-06-12' => 200,
            '2018-06-13' => 200,
            '2018-06-14' => 250,
            '2018-06-15' => 250,
            '2018-06-16' => 100,
          },
          'total'         => 1000
        }
      )

      expect { ImportReservations.call }.to change { Reservaton.count }.from(0).to(2)

      expect(Reservation.all).to match_array(
        [
          have_attribute(
            'reservation_id' => '01234',
            'checkin_date'   => '2018-06-11',
            'checkout_date'  => '2018-06-16',
            'guest_name'     => 'Tony Stark',
            'room_id'        => '887-06-16',
            'rates'          => {
              '2018-06-11' => 100,
              '2018-06-12' => 200,
              '2018-06-13' => 250,
              '2018-06-14' => 250,
              '2018-06-15' => 100,
            },
            'total'          => 900
          ),
          have_attribute(
            'reservation_id' => '01235',
            'checkin_date'   => '2018-06-12',
            'checkout_date'  => '2018-06-17',
            'guest_name'     => 'Steve Rogers',
            'room_id'        => '887-06-17',
            'rates'          => {
              '2018-06-12' => 200,
              '2018-06-13' => 200,
              '2018-06-14' => 250,
              '2018-06-15' => 250,
              '2018-06-16' => 100,
            },
            'total'          => 1000
          )
        ]
      )
    end

    it 'does not import duplicates' do
      create(:reservation, reservation_id: '01234')
      allow(ServiceX::Client).to receive(:get_all_reservations).and_return(
        [{ 'reservationID' => '01234' }]
      )

      expect { ImportReservations.call }.not_to change { Reservaton.count }
    end
  end
end
