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
    end
  end
end
