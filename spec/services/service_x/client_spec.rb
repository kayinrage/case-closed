require 'rails_helper'

module ServiceX
  RSpec.describe Client do
    describe '.get_all_reservations' do
      it 'fetches all reservations from ServiceX' do
        stub_const('ServiceX::Client::API_URL', 'https://servicex.com/api/')
        set_access_token_as_valid('super_secret_key')
        stub_request(:get, 'https://servicex.com/api/all_reservations').
          with(
            headers: {
              'X-Api-KEY'    => 'super_secret_key',
              'Content-Type' => 'application/json',
              'Accept'       => 'application/json'
            },
          ).
          to_return(
            body:
              {
                'data' => [
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
              }.to_json
          )
        expect(Client.get_all_reservation).to match(
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
      end
    end

    describe '.get_reservation' do
      it 'fetches all information for specific reservation' do
        stub_const('ServiceX::Client::API_URL', 'https://servicex.com/api/')
        set_access_token_as_valid('super_secret_key')
        stub_request(:get, 'https://servicex.com/api/reservation/01234').
          with(
            headers: {
              'X-Api-KEY'    => 'super_secret_key',
              'Content-Type' => 'application/json',
              'Accept'       => 'application/json'
            }
          ).
          to_return(
            body:
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
              }.to_json
          )
        expect(Client.get_reservation('01234')).to match(
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
      end
    end
  end
end

