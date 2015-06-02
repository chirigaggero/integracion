class Banco < ActiveRecord::Base

  $micuenta= "556489daefb3d7030091bab8"

  def self.get_account
    return $micuenta
  end

#metodo para obtener mi saldo

  def self.obtener_mi_saldo

    header1 = {"Content-Type"=> "application/json"}
    result = HTTParty.get("http://chiri.ing.puc.cl/apolo/cuenta/#{$micuenta}",:headers => header1)


    case result.code

      when 200
        saldo= result[0]["saldo"]
       return saldo

      else
        
        Rails.logger.info("error en la conexion")
        return -1000
    end

  end

  #metodo para pagar a fabrica
  def self.pagar_a_fabrica total


    header1 = {"Content-Type"=> "application/json"}
    body= {

            "monto" => total,
            "origen" =>$micuenta,
            "destino" =>cuenta_fabrica,
    }
    result = HTTParty.put("http://chiri.ing.puc.cl/apolo/trx",:headers => header1,:body=>body.to_json)

    case result.code

      when 200
        transaccion= result["_id"]
        return transaccion

      else

        Rails.logger.info("error en la conexion")
        return nil
    end


  end


  #metodo que retorna la cuenta de la fabrica
def self.cuenta_fabrica

  params = ["GET"]
  security = Bodega.claveSha1(params)

  url = "http://integracion-2015-dev.herokuapp.com/bodega/fabrica/getCuenta"
  header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}


  result = HTTParty.get(url,:headers => header1 )


  case result.code

    when 200
      cuenta= result["cuentaId"]
      return cuenta

    else

      Rails.logger.info "error en la conexion"
      return -1000
  end


end



  #metodo para pagar a otro grupo

  def pagar_b2b cuenta_id, monto

  end


  def self.setear_cuenta cuenta
    $micuenta=cuenta
  end

end
