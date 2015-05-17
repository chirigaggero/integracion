class Bodega < ActiveRecord::Base

	$id_grupo = 'grupo8'
	$key_bodega = 'deZ6QPKA1KcBEPr'


	# Con un almacen id y sku se agregan a pedidos productos con sus ids
	def self.obtener_prods(almacen_id,cantidad,pedido)
		params=["GET",almacen_id,pedido.sku]
		security = Bodega.claveSha1(params)

		url="http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{pedido.sku}"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		##result tiene que ser LA repueat valida, no se como hacer esta verificacion
		if result
			contador=0
			result.each do |item|
				prod=Producto.create(prod_id: item["_id"])
				pedido.productos<<prod
				contador+=1
				if contador>=Integer(cantidad)
					break
				end
			end
		end

	end

	# Obtenemos la cantidad dispoble de productos de un sku
	def get_cantidad(url,header1,sku)
		cantidad=0
		result = HTTParty.get(url,:headers => header1 )
		#tiene que ser si la respuesta es valida, no se si es la forma. REVISAR
		if result
			result.each do |item|
				if item["_id"]==sku
					cantidad+=item["total"]
				end
			end
		end
		cantidad
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

	# Metodo que valida si hay producto - es el encargado de llamar a los otros metodos
	def self.validar_pedido?(pedido)

		cant = pedido.cantidad
		sku = pedido.sku
		hay = false
		contador = 0
		elegido=[]


		Bodega.first(4)[0..3].each do | almacen |
			params = ["GET", almacen.almacen_id]
			security = claveSha1(params)


			url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
			header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

			resultado = almacen.get_cantidad(url,header1,sku)

			if resultado>0

				if contador+resultado<cant
					contador+=resultado
					elegido.append [almacen.almacen_id,resultado]
				else
					elegido.append [almacen.almacen_id,cant-contador]
					hay=true
					break
				end
			end
		end

		if hay
			#hay que obtener los id's de los productos que vamos a usar.
			#necesitamos llamar a metodo getstock con el sku y el almacen id
			elegido.each do |eleg|

				if eleg[1]<100
					obtener_prods(eleg[0],eleg[1],pedido)


				else
					# No podemos acceder al servicio con mas de 100 productos
					return false
				end

			end

			despacho_id=Bodega.find_by_tipo("despacho").almacen_id

			pedido.mover_bodega(despacho_id)
			return true

		else
			false
		end

	end

end

