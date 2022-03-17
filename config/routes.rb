Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace 'api' do
    namespace 'v1' do
      resources :heroes
      resources :races
      get 'races/:id/get_heroes', to: 'races#get_heroes'
      get 'heroes/:id/get_race', to: 'heroes#get_race'
      post 'duel/fight'
    end
  end
end
