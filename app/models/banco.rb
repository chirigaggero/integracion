class Banco < ActiveRecord::Base

  $micuenta= "556489daefb3d7030091bab8"


#metodo para obtener mi saldo

  def self.obtener_mi_saldo

    header1 = {"Content-Type"=> "application/json"}
    result = HTTParty.get("http://chiri.ing.puc.cl/apolo/cuenta/#{$micuenta}",:headers => header1)


    case result.code

      when 200
        saldo= result[0]["saldo"]
       return saldo

      else
        
        Rails.logger("error en la conexion")
        return -1000
    end

  end

  #metodo para pagar a fabrica
  def pagar_a_fabrica total

  end

  #metodo para pagar a otro grupo

  def pagar_b2b cuenta_id

  end

end
