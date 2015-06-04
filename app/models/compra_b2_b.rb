class CompraB2B < ActiveRecord::Base
	def self.registro grupo
		# Grupo 3: http://integra3.ing.puc.cl/b2b/documentation/
		if grupo==3
			url = "http://integra3.ing.puc.cl/b2b/new_user/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.put(url, :headers => headers, :body => body.to_json)
		# Grupo 4: http://integra4.ing.puc.cl/public/documentation
		elsif grupo==4
			url = "http://integra4.ing.puc.cl/b2b/new_user.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		# Grupo 5: http://integra5.ing.puc.cl/b2b/documentation
		elsif grupo==5
			# API MALA
		# Grupo 6: http://integra6.ing.puc.cl/api/documentation
		elsif grupo==6
			# API MALA
		# Grupo 7: http://integra7.ing.puc.cl/api/documentation
		elsif grupo==7
			url = "http://integra7.ing.puc.cl/api/register_group"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end
	end

	def self.obtener_token grupo
		# Grupo 3: http://integra3.ing.puc.cl/b2b/documentation/
		if grupo==3
			registro 3
			url = "http://integra3.ing.puc.cl/b2b/get_token/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
			token = result["token"]
			return token
		# Grupo 4: http://integra4.ing.puc.cl/public/documentation
		elsif grupo==4
			registro 4
			url = "http://integra4.ing.puc.cl/b2b/get_token.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
			token = result["token"]
			return token
		# Grupo 5: http://integra5.ing.puc.cl/b2b/documentation
		elsif grupo==5
			registro 5
			# API MALA
		# Grupo 6: http://integra6.ing.puc.cl/api/documentation
		elsif grupo==6
			registro 6
			# API MALA
		# Grupo 7: http://integra7.ing.puc.cl/api/documentation
		elsif grupo==7
			registro 7
			url = "http://integra7.ing.puc.cl/api/get_token"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
			token = result["token"]
			return token
		end
	end

	def self.pedir order_id, sku
		# Grupo 3: http://integra3.ing.puc.cl/b2b/documentation/
		if sku==20 #cacao
			token = obtener_token 3

			url = "http://integra3.ing.puc.cl/b2b/new_order/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end
		# Grupo 4: http://integra4.ing.puc.cl/public/documentation
		if sku==19 #semola
			token = obtener_token 4

			url = "http://integra4.ing.puc.cl/b2b/new_order.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"token" => token, "order_id" => order_id}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		end
		# Grupo 5: http://integra5.ing.puc.cl/b2b/documentation
		if sku==26 #sal
			token = obtener_token 5
			# api mala
		end
		# Grupo 6: http://integra6.ing.puc.cl/api/documentation
		if sku==7 #leche
			token = obtener_token 6
			# api mala
		end
		# Grupo 7: http://integra7.ing.puc.cl/api/documentation
		if sku==2 #huevo
			token = obtener_token 7

			url = "http://integra7.ing.puc.cl/api/create_order"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "authorization" => "#{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end
	end

	def self.aceptar_orden order_id, cliente
		if cliente=="grupo1"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo2"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo3"
			token = obtener_token 3
			url = "http://integra3.ing.puc.cl/b2b/order_accepted/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo4"
			token = obtener_token 4
			url = "http://integra4.ing.puc.cl/b2b/order_accepted.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"token" => token, "order_id" => order_id}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo5"
			token = obtener_token 5
			url = "http://integra5.ing.puc.cl/b2b/order_accepted/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo6"
			# API MALA
		elsif cliente=="grupo7"
			token = obtener_token 7
			url = "http://integra7.ing.puc.cl/api/accepted_order"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "authorization" => "#{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.put(url, :headers => headers, :body => body.to_json)
		end
	end

	def self.rechazar_orden order_id, cliente
		if cliente=="grupo1"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo2"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo3"
			token = obtener_token 3
			url = "http://integra3.ing.puc.cl/b2b/order_rejected/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo4"
			token = obtener_token 4
			url = "http://integra4.ing.puc.cl/b2b/order_rejected.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"token" => token, "order_id" => order_id}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo5"
			token = obtener_token 5
			url = "http://integra5.ing.puc.cl/b2b/order_rejected/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo6"
			# API MALA
		elsif cliente=="grupo7"
			token = obtener_token 7
			url = "http://integra7.ing.puc.cl/api/rejected_order"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "authorization" => "#{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.put(url, :headers => headers, :body => body.to_json)
		end
	end

	# conectarse a servicio de factura  y entregar el id de la factura creada a partir de una orden de compra
	def self.generar_factura order_id


		url="http://moyas.ing.puc.cl:8080/Jboss/integra8/Factura"
		headers = {"Content-Type"=> "application/json"}
		body = {"oc" => order_id}
		result = HTTParty.put(url, :headers => headers, :body => body.to_json)

		#retornar id de la factura
		case result.code

			when 200
				id= result["_id"]
				return id
			when 202
				id= result["_id"]
				return id

			else
				Rails.logger.info "error en la conexion #{result.code}"
				return -1000
		end

	end

	def self.obtener_factura factura_id


		url="http://moyas.ing.puc.cl:8080/Jboss/integra8/Factura"
		headers = {"Content-Type"=> "application/json"}
		body = {"oc" => order_id}
		result = HTTParty.put(url, :headers => headers, :body => body.to_json)

		#retornar id de la factura
		case result.code

			when 200
				id= result["_id"]
				return id
			when 202
				id= result["_id"]
				return id

			else
				Rails.logger.info "error en la conexion #{result.code}"
				return -1000
		end

	end





	def self.notificar_factura cliente,order_id

		if cliente=="grupo1"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo2"
			# NO INTERACTUAMOS CON ELLOS
		elsif cliente=="grupo3"
			token = obtener_token 3
			url = "http://integra3.ing.puc.cl/b2b/invoice_paid"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"invoice_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo4"
			token = obtener_token 4
			url = "http://integra4.ing.puc.cl/b2b/invoice_paid.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"token" => token, "invoice_id" => order_id}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo5"
			token = obtener_token 5
			url = "http://integra5.ing.puc.cl/b2b/invoice_paid"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"invoice_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		elsif cliente=="grupo6"
			# API MALA
		elsif cliente=="grupo7"
			token = obtener_token 7
			url = "http://integra7.ing.puc.cl/api/issued_invoice"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "authorization" => "#{token}"}
			body = {"invoice_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end

	end

	def self.test_whenever
		Rails.logger.info("estoy funcionando whenever")
	end


end
