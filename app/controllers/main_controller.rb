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

    @numero_redes = params[:numero_redes].to_i
    @numero_seriales = params[:numero_seriales].to_i

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

    resultados = calcular_vlsm(@nombres, @hosts, @ip_inicial, @msk_inicial)

    File.open('resultados.txt', 'w+') do |f|
      resultados.map { |x|
        f.puts "Nombre:\t\t#{x[:nombre]}"
        f.puts "Red:\t\t#{x[:red]} /#{x[:mascara_num]}"
        f.puts "Mascara:\t#{x[:mascara]}"
        f.puts "Primer host:\t#{x[:primer_host]}"
        f.puts "Ultimo host:\t#{x[:ultimo_host]}"
        f.puts "Total de host:\t#{x[:host_total]}"
        f.puts "broadcast:\t#{x[:broadcast]}"
        f.puts "---"
      }
    end

    render text: "OK"

  end

  def sing_in
    @p = params[:requerimientos]
    render text: "Texto: #{p.texto} y Numero: #{p.numero}"
  end

  def sing_up
  end
end
