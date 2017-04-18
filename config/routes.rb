Rails.application.routes.draw do

  # Controlador Main
  get 'main/index'

  get 'main/sing_in'

  get 'main/sing_up'

  post 'main/get_datos_redes'
  get 'main/get_datos_redes'

  post 'main/calcular_redes'
  get 'main/calcular_redes'

  # Ruta raiz
  root to: 'main#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
