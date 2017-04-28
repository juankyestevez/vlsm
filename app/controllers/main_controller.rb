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
    @archivo_txt = generar_txt(Time.now, @resultados)
    @archivo_excel = generar_excel(Time.now, @resultados)
  end


  def descargar_txt
    @archivo = params[:archivo_txt]

    send_file(
      "#{Rails.root}/public/resultados/txt/#{@archivo}",
      filename: "reporte_#{@archivo}",
      type: "application/txt"
    )
  end


  def descargar_xlsx
    @archivo = params[:archivo_excel]

    send_file(
      "#{Rails.root}/public/resultados/excel/#{@archivo}",
      filename: "reporte_#{@archivo}",
      type: "application/xlsx"
    )
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


  def formato_fecha(fecha)
    if fecha.day.to_i < 10
      dia = "0" + fecha.day.to_s
    else
      dia = fecha.day.to_s
    end
    if fecha.month.to_i < 10
      mes = "0" + fecha.month.to_s
    else
      mes = fecha.month.to_s
    end
    if fecha.hour.to_i < 10
      hora = "0" + fecha.hour.to_s
    else
      hora = fecha.hour.to_s
    end
    if fecha.min.to_i < 10
      minutos = "0" + fecha.min.to_s
    else
      minutos = fecha.min.to_s
    end
    if fecha.sec.to_i < 10
      segundos = "0" + fecha.sec.to_s
    else
      segundos = fecha.sec.to_s
    end

    return "#{fecha.year}#{mes}#{dia}#{hora}#{minutos}#{segundos}"

  end


  def generar_txt(fecha, arreglo)
    archivo_aux = "#{formato_fecha(fecha)}.txt"
    nombre_txt = "#{Rails.root}/public/resultados/txt/#{archivo_aux}"

    File.open(nombre_txt, 'w+') do |f|
      arreglo.map do |x|
        f.puts "Nombre:\t\t#{x[:nombre]}\r"
        f.puts "Red:\t\t#{x[:red]} /#{x[:mascara_num]}\r"
        f.puts "Mascara:\t#{x[:mascara]}\r"
        f.puts "Primer host:\t#{x[:primer_host]}\r"
        f.puts "Ultimo host:\t#{x[:ultimo_host]}\r"
        f.puts "Total de host:\t#{x[:host_total]}\r"
        f.puts "broadcast:\t#{x[:broadcast]}\r"
        f.puts "---\n\n\r"
      end
    end

    return archivo_aux
  end


  def generar_excel(fecha, arreglo)
    archivo_aux = "#{formato_fecha(fecha)}.xlsx"
    nombre = "#{Rails.root}/public/resultados/excel/#{archivo_aux}"

    # Create a new Excel workbook
    workbook = WriteXLSX.new(nombre)

    # Add a worksheet
    worksheet = workbook.add_worksheet('Calculadora - VLSM')
    #8<x<64, R, G, B
    #color_titulo = workbook.set_custom_color(8, 0, 32, 96)

    # Formato titulo1
    titulo1 = workbook.add_format # Add a format
    titulo1.set_bold
    titulo1.set_size(20)
    titulo1.set_bg_color('black')
    titulo1.set_color('white')
    titulo1.set_align('center')
    # Formato titulo2
    titulo2 = workbook.add_format # Add a format
    titulo2.set_size(14)
    titulo2.set_bg_color('black')
    titulo2.set_color('white')
    titulo2.set_align('center')
    # Formato centro
    centro = workbook.add_format # Add a format
    centro.set_size(11)
    centro.set_align('center')
    centro.set_border(1)

    # Formato columnas
    worksheet.set_column(0, 0, 4, nil) #4, 20, 30, 15
    worksheet.set_column(1, 8, 25, nil)

    # Encabezado
    worksheet.merge_range('A1:H1', 'CALCULADORA VLSM', titulo1)
    worksheet.merge_range('A2:H2', 'vlsm.herokuapp.com', titulo2)

    # [No., Nombre, Apellido, telefono, Email, institucion, Curso, producto, codigo, fecha]
    worksheet.write(3, 0, "No.", titulo2)
    worksheet.write(3, 1, "Nombre de la red", titulo2)
    worksheet.write(3, 2, "Direccion de red", titulo2)
    worksheet.write(3, 3, "Mascara", titulo2)
    worksheet.write(3, 4, "Primer Host", titulo2)
    worksheet.write(3, 5, "Ultimo host", titulo2)
    worksheet.write(3, 6, "Total de host", titulo2)
    worksheet.write(3, 7, "Broadcast", titulo2)

    # Cuerpo del archivo
    num = 4
    arreglo.each do |x|
      worksheet.write(num, 0, num-3, centro)
      worksheet.write(num, 1, x[0], centro)
      worksheet.write(num, 2, x[1], centro)
      worksheet.write(num, 3, "#{x[2]} /#{x[3]}", centro)
      worksheet.write(num, 4, x[4], centro)
      worksheet.write(num, 5, x[5], centro)
      worksheet.write(num, 6, x[6], centro)
      worksheet.write(num, 7, x[7], centro)
      num += 1
    end

    workbook.close

    return archivo_aux
  end



end
