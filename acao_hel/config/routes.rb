Rails.application.routes.draw do
  namespace :ygg do
    namespace :acao do
      hel_resources :flights, controller: 'flight/rest' do
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

    end
  end
end
