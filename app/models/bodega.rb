class Bodega < ActiveRecord::Base


  def aceptar_pedido?(pedido)

  end

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

end
