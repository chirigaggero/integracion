class Producto < ActiveRecord::Base


  def moverse?(bodega_id)
    ##primero tenemos que hashear
    params=["POST",self.prod_id, bodega_id]
    security = Bodega.claveSha1(params)

    url="http://integracion-2015-dev.herokuapp.com/bodega/moveStock"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body= { "productoId" => self.prod_id,
           "almacenId" =>bodega_id ,
    }

    #return body

    result = HTTParty.post(url,:headers => header1,:body=>body.to_json)

    if result
      true
    else
      false
    end
  end

end
