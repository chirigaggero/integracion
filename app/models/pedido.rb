class Pedido < ActiveRecord::Base
  has_many :productos



  def mover_bodega(id_bodega)
    self.productos.each do  |prod|

      a = prod.moverse?(id_bodega)

      Producto.delete(prod)
    end

  end


end
