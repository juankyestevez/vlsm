Rails.application.routes.draw do

  # Controlador Main
  get 'main/index'

  get 'main/sing_in'

  get 'main/sing_up'


  # Ruta raiz
  root to: 'main#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
