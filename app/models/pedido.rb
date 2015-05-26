class Pedido < ActiveRecord::Base
  has_many :productos



  def mover_a_bodega(id_bodega)
    self.productos.each do  |prod|

      a = prod.moverse?(id_bodega)

     # Producto.delete(prod)
    end

  end


  def despachar

    cantidad=self.cantidad-self.cantidadDespachada

    # mover al almacen de despacho, un producto a la vez




  end


end
