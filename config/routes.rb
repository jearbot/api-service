Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/drivers', to: 'drivers#show'
    end
  end
end
