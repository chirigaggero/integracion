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

    cantidad_pedido=self.cantidad

    # mover al almacen de despacho, un producto a la vez
    Bodega.first(2)[0..1].each do | almacen |

      params = ["GET", almacen.almacen_id]
      security = Bodega.claveSha1(params)


      url = "http://integracion-2015-prod.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
      header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

      prod_almacen = almacen.get_cantidad_total(url,header1,Integer(self.sku))

      Rails.logger.info("cantidad inicial:#{prod_almacen}")
      while(prod_almacen>0 and cantidad_pedido>0)

        producto = Bodega.obtener_id_producto(almacen.almacen_id,self.sku)

        #mover a almacen de despacho

        Bodega.mover_producto(producto, id_despacho)

          #mover a la bodega del cliente
          if self.ftp
            Bodega.mover_ftp(producto,self.direccion)
          else
            Bodega.mover_b2b?(producto,self.direccion)
          end


            prod_almacen-= 1
            cantidad_pedido-= 1



      end

      if cantidad_pedido == 0
        Rails.logger.info("cantidad final:#{prod_almacen}")
        break
      end

    end


  end


end
