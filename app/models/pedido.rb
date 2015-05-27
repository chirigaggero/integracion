class Pedido < ActiveRecord::Base
  has_many :productos



  def mover_a_bodega(id_bodega)
    self.productos.each do  |prod|

      a = prod.moverse?(id_bodega)

     # Producto.delete(prod)
    end

  end


  def despachar

    id_despacho= Bodega.id_bodegaDespacho
    cantidad_pedido=self.cantidad-self.cantidadDespachada

    # mover al almacen de despacho, un producto a la vez
    Bodega.first(2)[0..1].each do | almacen |

      params = ["GET", almacen.almacen_id]
      security = claveSha1(params)


      url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
      header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

      prod_almacen = almacen.get_cantidad_total(url,header1,self.sku)

      while(prod_almacen>0 and cantidad_pedido>0)

        producto = Bodega.obtener_producto(almacen_pedido,self)

        #mover a almacen de despacho
        if producto.mover_a_almacen?(id_despacho)

          #mover a la bodega del cliente
          if producto.mover_b2b?(pedido.direccion)
            prod_almacen-= 1
            cantidad_pedido-= 1

          end

        end

      end

      if cantidada_pedido == 0
        break
      end

    end

    #Supooniendo que se envio el pedido completo, se manda la factura de la compra



  end


end
