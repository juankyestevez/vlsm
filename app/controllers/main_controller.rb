class MainController < ApplicationController

  # Accion Principal - Root Path
  def index
  
  end

  # Accion par recolectar datos de las redes
  def get_datos_redes
    @numero_redes = params[:no_redes].to_i
    @numero_seriales = params[:no_seriales].to_i
  end

  def calcular_redes
    render text: "RED1: #{params[:red1_nombre]}  --  RED2: #{params[:red2_nombre]}"
  end

  def sing_in
    @p = params[:requerimientos]
    render text: "Texto: #{p.texto} y Numero: #{p.numero}"
  end

  def sing_up
  end
end
