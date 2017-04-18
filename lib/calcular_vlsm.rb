require 'metodos'
require 'vlsm'

def calcular_vlsm(nombres, hosts, ip, msk)
  main_hash = arrays_to_hash(nombres, hosts)
  main_hash = sort_hash(main_hash)
  hosts_aux = main_hash.values
  nombres_aux = main_hash.keys

  estructura = Struct.new(:nombre, :red, :mascara, :mascara_num, :primer_host, :ultimo_host, :host_total, :broadcast)
  resultados = []

  vlsm = VLSM.new(ip, msk)

  (0...hosts_aux.size).map { |x|
    nombre = nombres_aux[x]
    red = vlsm.calculate_network
    mascara = vlsm.calculate_mask(hosts_aux[x])
    mascara_num = vlsm.calculate_mask_num(hosts_aux[x])
    primer_host = vlsm.calculate_first_host
    ultimo_host = vlsm.calculate_last_host(hosts_aux[x])
    total_hosts = vlsm.calculate_no_hosts(hosts_aux[x])
    broadcast = vlsm.calculate_broadcast(hosts_aux[x])
    resultados << estructura.new(nombre, red, mascara, mascara_num,
                  primer_host, ultimo_host, total_hosts, broadcast)
    vlsm.ip = vlsm.calculate_next_network(hosts_aux[x])
  }

  resultados

end
