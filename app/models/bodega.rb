class Bodega < ActiveRecord::Base



	def aceptar_pedido?(pedido)

	end

	def buscar_producto?(pedido_sku)
		almacenes = HTTParty.GET("http://integracion-2015-dev.herokuapp.com/bodega/almacenes")
			ids = []
			almacenes.each do | almacen |
				ids.append almacen[0]["Id"]
			end

			

		
	end
end
