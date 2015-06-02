class Transito < ActiveRecord::Base


  def self.cancelar_pedido sku_string

    transito=Transito.first
    sku=Integer(sku_string)

    case
      #dejamos de pedir el producto, puesto que rechazan nuestra orden de compra
      when 7
        transito.leche=false
        transito.save

      when 20
        transito.cacao=false
        transito.save
      when 25
        transito.azucar=false
        transito.save
      when 2
        transito.huevo=false
        transito.save
      when 19
        transito.semola=false
        transito.save
      when 26
        transito.sal=false
        transito.save
      else
        Rails.logger.info("Error en procesar el sku para cancelar pedidos")
        return nil

    end
#    datos_chocolate=[['leche',7,251,1],['cacao',20,296,1],['azucar',25,269,1]]

 #   datos_semola=[['huevo',2,155,1],['semola',19,160,1],['sal',26,172,1]]
  end
end
