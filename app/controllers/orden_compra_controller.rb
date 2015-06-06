class OrdenCompraController < ApplicationController
	def estado

		$query = params["q"]

		url = "http://moyas.ing.puc.cl:8080/Jboss/integra8/OrdenCompra/obtener/#{$query}"
		result = HTTParty.get(url)
		$order_id = result[0]["_id"]
		$cliente = result[0]["cliente"]
		$proveedor = result[0]["proveedor"]
		$sku = result[0]["sku"]
		$estado = result[0]["estado"]
		$fechaEntrega = result[0]["fechaEntrega"]
		$precioUnitario = result[0]["precioUnitario"]
		$cantidadDespachada = result[0]["cantidadDespachada"]
		$cantidad = result[0]["cantidad"]
		$canal = result[0]["canal"]

	@cantidad_disponible= Bodega.cantidad_disponible_sku_reposicion $sku




		@pedidos=Pedido.all


	end
end
