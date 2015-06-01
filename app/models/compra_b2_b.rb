class CompraB2B < ActiveRecord::Base
	def self.registro
		# Grupo 3: http://integra3.ing.puc.cl/b2b/documentation/
		url = "http://integra3.ing.puc.cl/b2b/new_user/"
		headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
		body = {"username" => "grupo8", "password" => "grupo8ti2015"}
		result = HTTParty.put(url, :headers => headers, :body => body.to_json)
		# Grupo 4: http://integra4.ing.puc.cl/public/documentation
		url = "http://integra4.ing.puc.cl/b2b/new_user.json"
		headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
		body = {"username" => "grupo8", "password" => "grupo8ti2015"}
		result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		# Grupo 5: http://integra5.ing.puc.cl/b2b/documentation
			# ?????
		# Grupo 6: http://integra6.ing.puc.cl/api/documentation
			# ?????
		# Grupo 7: http://integra7.ing.puc.cl/api/documentation
		url = "http://integra7.ing.puc.cl/api/register_group"
		headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
		body = {"username" => "grupo8", "password" => "grupo8ti2015"}
		result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		
	end
	def self.pedir order_id, sku
		# Grupo 3: http://integra3.ing.puc.cl/b2b/documentation/
		if sku==20 #cacao
			url = "http://integra3.ing.puc.cl/b2b/get_token/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
			token = result["token"]

			url = "http://integra3.ing.puc.cl/b2b/new_order/"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end
		# Grupo 4: http://integra4.ing.puc.cl/public/documentation
		if sku==19 #semola
			url = "http://integra4.ing.puc.cl/b2b/get_token.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
			token = result["token"]

			# AL MOMENTO DE PROGRAMAR LA API DE ESTE GRUPO NO ESTABA CORRECTA: REVISAR
			url = "http://integra4.ing.puc.cl/b2b/new_order.json"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "Authorization" => "Token #{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
		end
		# Grupo 5: http://integra5.ing.puc.cl/b2b/documentation
			# ??????
		if sku==26 #sal
			
		end
		# Grupo 6: http://integra6.ing.puc.cl/api/documentation
			# API MALA
		if sku==7 #leche
			
		end
		# Grupo 7: http://integra7.ing.puc.cl/api/documentation
		if sku==2 #huevo
			url = "http://integra7.ing.puc.cl/api/get_token"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
			body = {"username" => "grupo8", "password" => "grupo8ti2015"}
			result = HTTParty.get(url, :headers => headers, :body => body.to_json)
			token = result["token"]

			url = "http://integra7.ing.puc.cl/api/create_order"
			headers = {"Content-Type"=> "application/json", "Accept" => "application/json", "authorization" => "#{token}"}
			body = {"order_id" => order_id}
			result = HTTParty.post(url, :headers => headers, :body => body.to_json)
		end
	end

	def self.test_whenever
		#Rails.logger.info("estoy funcionando whenever")	
	end
end
