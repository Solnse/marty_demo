Rails.application.routes.draw do

  netzke
  mount Marty::Engine => "/orion"
  get 'components/:component' => 'orion/components#index', as: "components"
  get 'marty/components/:component' => 'marty/components#index', as: "marty/components"
  root 'orion/components#home'

end
