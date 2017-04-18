# CONVIERTE UNA DIRECCION IP (STRING) EN UN ARRAY
def to_array(param)
  param.split(".").map {|x| x.to_i}
end

# CONVIERTE UN ARRAY EN UNA DIRECCION IP (STRING)
def to_string(param)
  param.join(".")
end

# ORDENA UN HASH DEL MAYOR VALOR AL MENOR
def sort_hash(param)
  orden = param.sort_by { |n, v| v }.reverse
  array_to_hash(orden)
end

# CONVIERTE UN ARRAY BIDIRECCIONAL EN UN HASH
def array_to_hash(param)
  arr = {}
  param.each{ |aux|
    arr[aux[0]] = aux[1]
  }
  arr
end

# CONVIERTE DOS ARRAYS EN UN HASH KEY-VALUE
def arrays_to_hash(arr1, arr2)
  res = {}
  (0...arr1.size).each { |x|
    res[arr1[x]] = arr2[x]
  }
  res
end

def elements_to_array(*args)
  args
end
