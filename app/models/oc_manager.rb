class OcManager < ActiveRecord::Base


  def self.crear_orden sku, cantidad, precio

    case sku
      when 20
        cliente= "grupo3"
      when 7
        cliente = "grupo6"
      when 25
        cliente = "grupo8"
      when 2
        cliente= "grupo7"
      when 19
        cliente= "grupo4"
      when 26
        cliente="grupo5"
      else
        cliente="error"

    end

    url = "http://chiri.ing.puc.cl/atenea/crear"
    header1 = {"Content-Type"=> "application/json"}
    body= {

        "canal" => "b2b",
        "cantidad" =>cantidad ,
        "sku" =>sku,
        "proveedor" => 'grupo8',
        "precioUnitario" => precio,
        #"notas" =>'nada que decir',
        "cliente"=> cliente,
        "fechaEntrega" =>DateTime.tomorrow.to_time.to_i*1000

    }

    result = HTTParty.put(url,:headers => header1,:body => body.to_json )


    case result.code

      when 200
        id= result["_id"]
        return id

      else

        Rails.logger.info "error en la conexion"
        return -1000
    end


  end

  def self.obtener_orden order_id
    headers = {"Content-Type"=> "application/json"}
    orden = HTTParty.get("http://chiri.ing.puc.cl/atenea/obtener/#{order_id}",:headers => headers)
  end

end
