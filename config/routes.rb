Rails.application.routes.draw do

  # Controlador Main
  get 'main/index'

  get 'main/get_datos_redes'
  post 'main/get_datos_redes'

  post 'main/calcular_redes'

  get 'main/sing_in'

  get 'main/sing_up'

  post 'main/descargar_txt'
  post 'main/descargar_xlsx'

  # Las rutas no encontradas son redirigidas a la ruta raiz
  get "*path" => redirect("/")
  post "*path" => redirect("/")

  # Ruta raiz
  root to: 'main#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
