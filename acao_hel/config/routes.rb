Rails.application.routes.draw do
  namespace :ygg do
    namespace :acao do
      hel_resources :flights, controller: 'flight/rest' do
      end

      hel_resources :trailers, controller: 'trailer/rest' do
      end

      hel_resources :trackers, controller: 'tracker/rest' do
      end

      hel_resources :aircrafts, controller: 'aircraft/rest' do
        collection do
          get 'by_code/:id(.:format)' => :by_code
        end
      end

      hel_resources :aircraft_types, controller: 'aircraft_type/rest' do
      end

      hel_resources :pilots, controller: 'pilot/rest' do
      end

      hel_resources :meters, controller: 'meter/rest' do
      end

      hel_resources :meter_buses, controller: 'meter_bus/rest' do
      end

      hel_resources :timetable_entries, controller: 'timetable_entry/rest' do
      end

      hel_resources :pilots, controller: 'pilot/rest' do
      end

      hel_resources :airfields, controller: 'airfield/rest' do
      end

      hel_resources :radar_points, controller: 'radar_point/rest' do
        collection do
          get 'track/:year/:month/:day/:aircraft_id' => :track_day
          get 'track' => :track
        end
      end

      hel_resources :memberships, controller: 'membership/rest' do
        collection do
          get 'renew' => :renew_context
          post 'renew' => :renew_do
        end
      end

      hel_resources :licenses, controller: 'license/rest' do
      end

      hel_resources :medicals, controller: 'medical/rest' do
      end

      hel_resources :service_types, controller: 'service_type/rest' do
      end

      hel_resources :roster_days, controller: 'roster_day/rest' do
      end

      hel_resources :roster_entries, controller: 'roster_entry/rest' do
        collection do
          get 'status' => :get_status
        end

        member do
          post :offer
          post :offer_cancel
          post :offer_accept
        end
      end

      hel_resources :tow_roster_days, controller: 'tow_roster_day/rest' do
      end

      hel_resources :tow_roster_entries, controller: 'tow_roster_entry/rest' do
      end

      hel_resources :years, controller: 'year/rest' do
      end

      hel_resources :payments, controller: 'payment/rest' do
        collection do
          get 'satispay_callback' => :satispay_callback
          post 'satispay_callback' => :satispay_callback
        end

        member do
          post 'complete' => :complete
        end
      end

      hel_resources :invoices, controller: 'invoice/rest' do
      end

      hel_resources :member_services, controller: 'member_service/rest' do
      end

      post 'password_recovery' => 'password_recovery#recover'
    end
  end
end
