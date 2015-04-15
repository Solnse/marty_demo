Rails.application.routes.draw do

  netzke
  mount Marty::Engine => "/marty_demo"
  get 'components/:component' => 'marty_demo/components#index', as: "components"
  get 'marty/components/:component' => 'marty/components#index', as: "marty/components"
  root 'marty_demo/components#home'

end
