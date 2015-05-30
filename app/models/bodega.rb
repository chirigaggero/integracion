class Bodega < ActiveRecord::Base

	$id_grupo = 'grupo8'
	$key_bodega = 'DYzY6bQ3XxcyyPm'



  def self.id_bodegaDespacho
    return Bodega.where(tipo: 'despacho').almacen_id
  end


  def self.enviar_a_fabrica sku, transaccion, cantidad

    params = ["PUT",sku,cantidad,transaccion]
    security = Bodega.claveSha1(params)
return security
    url = "http://integracion-2015-dev.herokuapp.com/bodega/fabrica/fabricar"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body= {
        "sku" => sku,
        "trxId" => transaccion,
        "cantidad" =>cantidad

    }

    result = HTTParty.put(url,:headers => header1,:body => body.to_json )
    return result.to_s


  end


	def self.revisar_stock
		# revisar si tenemos los productos que distribuimos.
		#25,43,45
		skus_materiaprima=[25,43,45]
    skus_complejos = [46,48]

		#revisar en las bodegas, y devolver cantidad. [primero las materias primas]
    skus_materiaprima.each do |sku|
     disponible =  cantidad_disponible_sku_reposicion sku
     #si es menor a 1000, tenemos que pedir a fabrica.
      if disponible < 1000
        #cantidad requerida
        requerido=1000-disponible +10
        #precio de sku?
        precio =1
        #costo de la compra
        costo=precio*requerido
        #plata disponible en mi cuenta
				saldo= Banco.obtener_mi_saldo
				if saldo>=costo
					#hacer transferencia a fabrica, guardamos el id de la transferencia
          transferencia = Banco.pagar_a_fabrica costo
          #enviar a producir a la fabrica

				else
					Rails.logger.info("No hay money para producir prod: #{sku}")
					break
				end



      end
    end





	end





	# Con un almacen id y sku obtenemos el primer producto disponible.
	def self.obtener_producto(almacen_id,pedido)

		params = ["GET",almacen_id,pedido.sku]
		security = Bodega.claveSha1(params)

		url = "http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{pedido.sku}&limit=1"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		##result tiene que ser LA repueat valida, no se como hacer esta verificacion pero
		##vamos a asumir que si no es nula entonces est� bien.

		if !result.nil?
			contador=0
			##pedidos=Pedido.first(Pedido.count-1)
			result.each do |item|

				#no es necesario, pero lo voy a dejar.

        prod = Producto.create(prod_id: item["_id"])
        pedido.productos<<prod

				return prod

      end
    end

  end




	##asigna id de productos a un pedido.
	def armar_pedido?(pedido)
		##conectarse a un almacen
		prods_necesitados=pedido.cantidad

		Bodega.first(4)[0..3].each do | almacen |

		prods_necesitados-=crear_prods(almacen.id,pedido,prods_necesitados)

		if prods_necesitados.equal?(0)
			return true
			end
		end
		return false
	end


	# Obtenemos la cantidad total disponible de productos de un sku
	def get_cantidad_total(url,header1,sku)
		cantidad=0
		result = HTTParty.get(url,:headers => header1 )
		#tiene que ser si la respuesta es valida, no se si es la forma. REVISAR
		case result.code

			when 200
			result.each do |item|
				if Integer(item["_id"])==sku
					cantidad+=Integer(item["total"])
				end
			end

			else
				Rails.logger.info("error en la conexion")
				return 0
		end
		return cantidad
	end

	# Encripta en sha1 base 64
	def self.claveSha1(params)
		if params.kind_of?(Array)
			to_hash = params.join("")
		else
			to_hash=params
		end

		aux = OpenSSL::HMAC.digest('sha1',$key_bodega, to_hash)
		security = Base64.encode64("#{aux}")
		security[0..-2]
	end

	# Metodo que valida si hay productos en bodega para satisfacer el pedido - es el encargado de llamar a los otros metodos
	def self.validar_pedido?(pedido)


	disponible = cantidad_disponible_sku_pedido pedido

		##si la cantidad es menor a la diferencia entre el total y lo usado, se acepta.
		if pedido.cantidad<=disponible
			true
		else
			false
		end
	end

	##obtener la cantidad disponible para efectos de reposicion
	def self.cantidad_disponible_sku_reposicion sku

		total = 0
		usado = 0

		#se itera sobre las primeras 4 bodegas
		Bodega.first(4)[0..3].each do | almacen |


			params = ["GET", almacen.almacen_id]
			security = claveSha1(params)


			url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
			header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

			##obtenemos la cantidad total de productos con sku='sku' del almacen
			resultado = almacen.get_cantidad_total(url,header1,sku)
			#se suma lo obtenido al total
			total+=resultado
		end

		##obtenemos lo usado por todos los pedidos
		pedidos = Pedido.all
		pedidos.each do |pedidox|
			if pedidox.sku.equal? sku
				#se suma la cantidad del pedido
				usado+=pedidox.cantidad
			end
		end

    return total-usado

	end

	##obtener la cantidad disponible para efectos de validar pedido
	def self.cantidad_disponible_sku_pedido pedido
		sku=pedido.sku
		#se itera sobre las primeras 4 bodegas
		Bodega.first(4)[0..3].each do | almacen |
			params = ["GET", almacen.almacen_id]
			security = claveSha1(params)


			url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
			header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

			##obtenemos la cantidad total del almacen
			resultado = almacen.get_cantidad_total(url,header1,sku)
			total+=resultado
		end

		##obtenemos lo usado por pedidos anteriores
		pedidos = Pedido.first(Pedido.count-1)[0..Pedido.count-2]
		pedidos.each do |pedidox|
			if pedidox.sku.equal? pedido.sku
				usado+=pedidox.cantidad
			end
    end

    return total-usado

	end




	#metodo que verifica que pedidos deben ser despachados "hoy" y los manda a despachar
	def despachar_pedidos_de_hoy

		pedidos = Pedido.where(fechaEntrega: DateTime.now.strftime("%Y-%m-%d")).or(estado: 'pendiente')

		pedidos.each do |pedido|

			pedido.despachar

		end

  end


  def self.vaciar_recepcion

		#datos a utilizar
		id_normal1 = Bodega.first.almacen_id
		id_normal2 = Bodega.second.almacen_id
		id_recepcion = Bodega.third.almacen_id

		capacidad_normal1 = capacidad_disponible(id_normal1)
		capacidad_normal2 = capacidad_disponible(id_normal2)

		#ver si el almacen de recepcion tiene productos
		skus = skus_de_almacen(id_recepcion)


		#para cada sku con stock tomar un id y moverlo
		skus.each do |item|

			id_producto = obtener_id_producto(id_recepcion, item)

			while !id_producto.nil?

				if capacidad_normal1 > 0
					mover_producto(id_producto, id_normal1)
					capacidad_normal1 -=1

				else capacidad_normal2 > 0
					mover_producto(id_producto, id_normal2)
					capacidad_normal2 -=1

				end

				id_producto = obtener_id_producto(id_recepcion, item)
			end

		end

	end



	#retorna un arreglo con los sku y cantidad de cada almacen
	def self.skus_de_almacen(almacen_id)

		#conexion y respuesta
		params = ["GET", almacen_id]
		security = Bodega.claveSha1(params)

		url="http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=#{almacen_id}"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		skus = []

		result.each do |listaSku|
			skus.append listaSku["_id"]
		end

		return skus

	end

	#retorna la capacidad disponible del almacen
	def self.capacidad_disponible(almacen_id)

		#conexion y respuesta
		params = ["GET"]
		security = Bodega.claveSha1(params)

		url = "http://integracion-2015-dev.herokuapp.com/bodega/almacenes"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		#Buscar el almacen dentro de la respuesta y retornar la capacidad disponible
		capacidad = 0

		result.each do |almacenes|

			if almacenes["_id"] == almacen_id
				capacidad = almacenes["totalSpace"]-almacenes["usedSpace"]
			end

		end

		return capacidad

	end

	#devuelve UN id de un producto en almacen
	def self.obtener_id_producto(almacen_id, sku)

		params = ["GET",almacen_id, sku]
		security = Bodega.claveSha1(params)

		url = "http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{sku}&limit=1"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		if !result.empty?
			result.each do |item|
				return item["_id"]
			end
		else
			return nil
		end
	end

	#mueve un producto de un almacen a otro
	def self.mover_producto(producto_id, almacen_id)

		params = ["POST",producto_id, almacen_id]
		security = Bodega.claveSha1(params)

		url = "http://integracion-2015-dev.herokuapp.com/bodega/moveStock"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
		body = 	{
							"productoId" => producto_id,
							"almacenId" => almacen_id
						}

		result = HTTParty.post(url,:headers => header1,:body=>body.to_json)

		case result.code
			when 200
				true
			else
				false
		end
	end


  def self.cambiar_clave(nueva_clave)
    $key_bodega = nueva_clave
  end



end

