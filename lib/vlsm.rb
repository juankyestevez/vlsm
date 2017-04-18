class VLSM

  attr_accessor :ip, :mask

  def initialize(ip, mask)
    @ip = get_network(ip, mask)
    @mask = mask
  end

  def calculate_mask(no_hosts)
    resp = redondear_base2(no_hosts)
    resp = generar_mascara(resp)
    to_string(resp)
  end

  def calculate_mask_num(no_hosts)
    resp = redondear_base2(no_hosts)
    resp = generar_mascara(resp)
    get_mascara_num(resp)
  end

  def calculate_network
    to_string(@ip)
  end

  def calculate_first_host
    resp = sumar_hosts(@ip, 1)
    to_string(resp)
  end

  def calculate_last_host(no_hosts)
    aux = redondear_base2(no_hosts-2)
    resp = sumar_hosts(@ip, aux)
    to_string(resp)
  end

  def calculate_no_hosts(no_hosts)
    resp = redondear_base2(no_hosts)
    resp -= 2
    resp.to_s
  end

  def calculate_broadcast(no_hosts)
    aux = redondear_base2(no_hosts-1)
    resp = sumar_hosts(@ip, aux)
    to_string(resp)
  end

  def calculate_next_network(no_hosts)
    aux = redondear_base2(no_hosts)
    sumar_hosts(@ip, aux)
  end

  private

  # SEPARA LA PORCION DE RED
  def get_network(ip, msk)
    ip_a = to_array(ip)
    msk_a = to_array(msk)
    res = []
    (0..ip_a.size-1).each { |i|
      res[i] = ip_a[i] & msk_a[i]
    }
    res
  end

  # SUMA UN NUMERO DE HOSTS A LA DIRECCION DE RED
  def sumar_hosts(red, hosts)
    red_inv = red.reverse
    sum1 = red_inv[0] + hosts
    sum2, sum3, sum4 = 0,0,0
    count1, count2, count3 = 0,0,0
    if sum1 > 255
      loop {
        count1 += 1
        sum1 -= 256
        break if sum1 <= 255
      }
      sum2 = red_inv[1] + count1
      if sum2 > 255
        loop {
          count2 += 1
          sum2 -= 256
          break if sum2 <= 255
        }
        sum3 = red_inv[2] + count2
        if sum3 > 255
          loop {
            count3 += 1
            sum3 -= 256
            break if sum3 <= 255
          }
          sum4 = red_inv[3] + count3
          red_inv[3] = sum4
        end
        red_inv[2] = sum3
      end
      red_inv[1] = sum2
    end
    red_inv[0] = sum1

    red_inv.reverse
  end

  # REDONDEA A LA POTENCIA DE 2 MAS CERCANA
  def redondear_base2(num)
    2**Math.log2(num+2).ceil
  end

  # DETERMINA EL NUMERO DE BITS NECESARIOS PARA
  # ALBERGAR CIERTO NUMERO DE HOSTS
  def numero_de_bits?(num)
    Math.log2(num).ceil
  end

  # GENERA UNA MASCARA DE RED PARA DETERMINADO
  # NUMERO DE HOSTS
  def generar_mascara(hosts)
    aux = numero_de_bits?(hosts)
    x = "11111111111111111111111111111111"
    (0..aux-1).each { |i|
      x[i] = "0"
    }
    x.reverse!
    arr = []
    arr[0] = x[0..7]
    arr[1] = x[8..15]
    arr[2] = x[16..23]
    arr[3] = x[24..31]
    arr.map! { |xx| xx.to_i(2) }
  end

  # RETORNA LA MASCAR EN FORMATO /XX
  def get_mascara_num(arr)
    aux = arr.map { |x| x.to_s(2) }.join("")
    aux.count("1")
  end


end
