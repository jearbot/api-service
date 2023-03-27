Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/rides', to: 'drivers#show'
    end
  end
end
