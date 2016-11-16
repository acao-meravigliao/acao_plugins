Rails.application.routes.draw do
  namespace :ygg do
    namespace :acao do
      hel_resources :flights do
      end

      hel_resources :planes do
        collection do
          get 'by_code/:id(.:format)' => :by_code
        end
      end

      hel_resources :meters, controller: 'meter/rest' do
      end

      hel_resources :meter_buses, controller: 'meter_bus/rest' do
      end

    end
  end
end
