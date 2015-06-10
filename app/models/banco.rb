class Banco < ActiveRecord::Base

  $micuenta= "55648ad3f89fed0300525003"

  def self.get_account
    return $micuenta
  end


  def self.obtener_cuenta_b2b cliente

    case cliente
      when "grupo3"
     return   "55648ad3f89fed0300525002"

      when "grupo4"
        return "55648ad3f89fed0300525004"

      when "grupo5"
        "55648ad3f89fed0300524ffd2"

      when "grupo6"
     return "55648ad3f89fed0300524fff"

      when "grupo7"
    return    "55648ad3f89fed0300525001"
    end

  end


#metodo para obtener mi saldo

  def self.obtener_mi_saldo

    header1 = {"Content-Type"=> "application/json"}

    response =   RestClient.get "http://moyas.ing.puc.cl:8080/Bancos/integra8/banco/banco/cuenta/#{$micuenta}"
    #response= HTTParty.get("http://moyas.ing.puc.cl:8080/Bancos/integra8/banco/banco/cuenta/#{$micuenta}")

#    begin
      parsed_response = JSON.parse(response)
 #   rescue JSON::ParserError, TypeError => e


  #  end

    #case result.code

   #   when 200
#        saldo= result[0]["saldo"]
 #      return saldo

  #    when 202
   #     saldo= result[0]["saldo"]
    #    return saldo

     # else
        
        #Rails.logger.info("error en la conexion")
        #return result
#    end

  end

  #metodo para pagar a fabrica
  def self.pagar_a_fabrica total


    header1 = {"Content-Type"=> "application/json"}
    body= {

            "monto" => total,
            "origen" =>$micuenta,
            "destino" =>cuenta_fabrica
    }
    result = HTTParty.put("http://moyas.ing.puc.cl:8080/Bancos/integra8/banco/trx",:headers => header1,:body=>body.to_json)

    case result.code

      when 200
        transaccion= result["id"]
        return transaccion
      when 202
        transaccion= result["id"]
        return transaccion

      else

        Rails.logger.info("error en la conexion")
        return result.to_s
    end


  end


  #metodo que retorna la cuenta de la fabrica
def self.cuenta_fabrica

  params = ["GET"]
  security = Bodega.claveSha1(params)

  url = "http://integracion-2015-prod.herokuapp.com/bodega/fabrica/getCuenta"
  header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}


  result = HTTParty.get(url,:headers => header1 )


  case result.code

    when 200
      cuenta= result["cuentaId"]
      return cuenta

    when 202
      cuenta= result["cuentaId"]
      return cuenta


    else

      Rails.logger.info "error en la conexion"
      return 10000000
  end


end



  #metodo para pagar a otro grupo

  def self.pagar_b2b cuenta_id, monto
      url = "http://moyas.ing.puc.cl:8080/Banco/integra8/Banco/trx"
      headers = {"Content-Type"=> "application/json"}
      body = {"monto" => monto, "origen" => $micuenta, "destino" => cuenta_id}
      result = HTTParty.put(url, :headers => headers, :body => body.to_json)
  end


  def self.setear_cuenta cuenta
    $micuenta=cuenta
  end

end
