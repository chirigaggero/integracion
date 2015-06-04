class Producto < ActiveRecord::Base


  def mover_a_almacen?(bodega_id)
    ##primero tenemos que hashear
    params=["POST",self.prod_id, bodega_id]
    security = Bodega.claveSha1(params)

    url="http://integracion-2015-prod.herokuapp.com/bodega/moveStock"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body= { "productoId" => self.prod_id,
           "almacenId" =>bodega_id
    }

    #return body

    result = HTTParty.post(url,:headers => header1,:body=>body.to_json)

    case result.code
      when 200
        true
      else
        false
    end
  end


  def mover_b2b?(bodega_id)

    params=["POST",self.prod_id ,bodega_id]
    security = Bodega.claveSha1(params)

    url="http://integracion-2015-prod.herokuapp.com/bodega/moveStockBodega"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body= { "productoId" => self.prod_id,
            "almacenId" =>bodega_id
    }

    result = HTTParty.post(url,:headers => header1,:body=>body.to_json)

    case result.code
      when 200
        true
      else
        false
    end

  end

end
