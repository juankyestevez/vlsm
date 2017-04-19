class MainController < ApplicationController

  require 'calcular_vlsm'

  # Accion Principal - Root Path
  def index

  end

  # Accion par recolectar datos de las redes
  def get_datos_redes
    @numero_redes = params[:no_redes].to_i || nil
    @numero_seriales = params[:no_seriales].to_i || nil
  end

  def calcular_redes
    @calculado = params[:calculado] || false

    @ip_inicial = params[:ip_inicial]
    @msk_inicial = params[:msk_inicial]

    @numero_redes = params[:no_redes].to_i
    @numero_seriales = params[:no_seriales].to_i

    unless msk_valida?(@msk_inicial)
      flash[:mensaje] = "La información ingresada es INCORRECTA"
      redirect_to controller: :main, action: :get_datos_redes, no_redes: @numero_redes, no_seriales: @numero_seriales
    end

    @nombres = []
    @hosts = []

    # Toma de datos
    (1..@numero_redes).each do |num|
      @nombres << params["red#{num}_nombre"]
      @hosts << params["red#{num}_hosts"].to_i
    end

    (1..@numero_seriales).each do |num|
      @nombres << params["serial#{num}_nombre"]
      @hosts << 2
    end
    # FIN Toma de datos

    # Calculo de resultados
    @resultados = calcular_vlsm(@nombres, @hosts, @ip_inicial, @msk_inicial)

=begin
    File.open('resultados.txt', 'w+') do |f|
      resultados.map do |x|
        f.puts "Nombre:\t\t#{x[:nombre]}"
        f.puts "Red:\t\t#{x[:red]} /#{x[:mascara_num]}"
        f.puts "Mascara:\t#{x[:mascara]}"
        f.puts "Primer host:\t#{x[:primer_host]}"
        f.puts "Ultimo host:\t#{x[:ultimo_host]}"
        f.puts "Total de host:\t#{x[:host_total]}"
        f.puts "broadcast:\t#{x[:broadcast]}"
        f.puts "---"
      end
    end
=end

  end


  def sing_in
    
  end


  def sing_up

  end


  private

  def msk_valida?(mascara)
    @ans = true
    @msk_array = mascara.split(".")
    @msk_array.map do |num|
      num = num.to_i
      p num
      unless num >= 0 && num <= 255
        @ans = false
      end
    end
    @ans
  end


end
