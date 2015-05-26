class Bodega < ActiveRecord::Base

	$id_grupo = 'grupo8'
	$key_bodega = 'deZ6QPKA1KcBEPr'


	# Con un almacen id y sku se agregan a pedidos productos con sus ids
	def self.crear_prods(almacen_id,pedido,prods_necesitados)

		params=["GET",almacen_id,pedido.sku]
		security = Bodega.claveSha1(params)

		url="http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{pedido.sku}&limit=200"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )

		##result tiene que ser LA repueat valida, no se como hacer esta verificacion pero
		##vamos a asumir que si no es nula entonces est� bien.

		if !result.nil?
			contador=0
			##pedidos=Pedido.first(Pedido.count-1)
			result.each do |item|
				##antes de crear el producto, hay que verificar que su id no este en los pedidos ya registrados en la base de datos
		##		aceptar=true

				#iterar sobre los pedidos, si el prod ya esta asignado, entonces cambia el bool aceptar a false.
				##pedidos.each do |pedido|
				##	if !pedido.productos.where(prod_id: item["_id"]).empty?
				#		aceptar=false
			#		end
		#		end
				#si no est� asignado, crea u producto con ese id y hace append sobre pedido.productos, aumenta el contador de productos
			#	if aceptar
					prod=Producto.create(prod_id: item["_id"])
					pedido.productos<<prod
					contador+=1
					##si se llego a la cantidad requerida, retornamos true
					if contador>=Integer(prods_necesitados)
						break
				end
			end
				return contador
			end
			##solo se llega aqui si no se alcanza la cantidad requerida, no deberia pasar pq ya hicimos el chequeo cuanto obtuvimos
			##los productos 'disponibles'
				return false
		#end
		end

	##No estamos usando este metodo, pero no lo voy a borrar x si las moscas
	def buscar_producto?(pedido)
		almacenes = HTTParty.GET("http://integracion-2015-dev.herokuapp.com/bodega/almacenes")
		almacenes.each do |almacen|
			id = almacen[0]["Id"]
			skuWS = HTTParty.GET("http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock#{id}")
			skusWS.each do |skws|
				if pedido.sku == skws[0]["Sku"]
					if pedido.cantidad == skws[0]["Cantidad"]
					end
				end
			end
		end
	end

	##con el almacen_id y un pedido.sku, ve cuantos productos ese almacen estan asignados a otro pedido, retorna un int.
	def get_cantidad_usada(almacen_id,pedido)
		#conexion y respuesta
		params=["GET",almacen_id,pedido.sku]
		security = Bodega.claveSha1(params)

		url="http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{pedido.sku}&limit=200"
		header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

		result = HTTParty.get(url,:headers => header1 )
		contador=0
		#ver si cada producto  est� en pedidos anteriores.
		pedidos=Pedido.first(Pedido.count-1)
		result.each do |item|
					pedidos.each do |pedido|
						if !pedido.productos.where(prod_id: item["_id"]).empty?
							contador+=1
						end
					end
		end

	contador
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


	# Obtenemos la cantidad total dispoble de productos de un sku
	def get_cantidad_total(url,header1,sku)
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

	# Metodo que valida si hay productos en bodega para satisfacer el pedido - es el encargado de llamar a los otros metodos
	def self.validar_pedido?(pedido)
		cant = pedido.cantidad
		sku = pedido.sku
		hay = false
		total = 0
		usado=0
		##elegido=[]

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
			pedidos=Pedido.first(Pedido.count-1)[0..Pedido.count-2]
			pedidos.each do |pedidox|
			if pedidox.sku.equal? pedido.sku
				usado+=pedidox.cantidad
			end
			end

		##si la cantidad es menor a la diferencia entre el total y lo usado, se acepta.
		if pedido.cantidad<=(total-usado)
			true
		else
			false
		end
	end

				##VERSION 1.0
				##tenemos que ver cuanto realmente tenemos disponible
				##usado= get_cantidad_usada(almacen.id,pedido)
				##disponible=resultado-usado
				##ver si necesitamos mas o menos de lo que tenemos disponible
				##si lo disponible es mayor que 0
				##==============

				##if disponible>0

	#			if contador+disponible<cant
					##si el pedido nos exige mas de lo que tenemos disponible
	#				contador+=disponible
					##hacemos append de el id del almacen y de la cantidad de prod. que usaremos en 'elegido'
	#				elegido.append [almacen.almacen_id,disponible]
					#si es menor, hacemos append de el id y la diferencia entre el contal y lo que llevamos
	#			else
					#elegido.append [almacen.almacen_id,cant-contador]
					##en teoria ya podemos satisfacer el pedido.
	#				hay=true
	#				break
	#			end


	#	if hay
			#hay que obtener los id's de los productos que vamos a usar.
			#necesitamos llamar a metodo getstock con el sku y el almacen id
	#		elegido.each do |eleg|
				#La condicion es pq si es >200, entonces tenemos problemas con el display de productos.
				# (tenemos limit=200)
	#			if eleg[1]<200
				#obtener prods retorna true si hay suficientes prods en bodega que no esten asignados a pedidos existentes
	#				if !obtener_prods?(eleg[0],eleg[1],pedido)
						## no se deberia llegar aqui nunca.
	#					return false
	#				end
	#			else
					# No hay forma de manejar pedidos >200 x almacen.
	#				return false
	#			end
	#		end
	#	else
			##si no hay, retornamos false
		#	return false
	#	end
	#end


	#metodo que verifica que pedidos deben ser despachados "hoy" y los manda a despachar
	def despachar_pedidos_de_hoy

		pedidos = Pedido.where(fechaEntrega: DateTime.now.strftime("%Y-%m-%d")).or(estado: 'pendiente')

		pedidos.each do |pedido|

			pedido.despachar

		end



	end





end

