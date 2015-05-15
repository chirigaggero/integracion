class Bodega < ActiveRecord::Base
	require 'rubygems'
	require 'base64'
	require 'cgi'
	require 'hmac-sha1'

	$id_grupo = 'grupo8'
	$key_bodega = 'deZ6QPKA1KcBEPr'


	def aceptar_pedido?(pedido)

	end

	def buscar_producto?(pedido_sku)
		almacenes = HTTParty.GET("http://integracion-2015-dev.herokuapp.com/bodega/almacenes")
			ids = []
			almacenes.each do | almacen |
				ids.append almacen[0]["Id"]
			end
		
	end

	# Metodo que obtendra la clave sha1.
	# Params es un arreglo entre GET,POST,DELETE ... mas los parametros del metodo

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

	#Revisar si hay inventario suficiente en la bodega
	def self.check(producto)

		cant = producto.cantidad
		sku = producto.sku
		hay = false
		contador = 0

		Almacenes.each do | almacen |

			params = ["GET", almacen.almacen_id]
			security = claveSha1(params)

			url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id

			header1 = {'Content-Type'=> 'application/json','Authorization' => 'INTEGRACION grupo8:#{security}'}

			@result = HTTParty.post(url,:headers => header1 )


		end




	end

end
