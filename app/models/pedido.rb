class Pedido < ActiveRecord::Base
  has_many :productos



  def mover_bodega(id_bodega)
    self.productos.each do  |prod|


      if prod.moverse?(id_bodega)
      else
        ##devolver error
      end
      ##no es necesario, pero veamos como anda asi.
      Producto.delete(prod)
    end

  end


end
