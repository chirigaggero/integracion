class PromoManager < ActiveRecord::Base

  CALLBACK_URL = "http://integra8.ing.puc.cl/"

  $token = "41805320.3f49652.296c36cc778d466fa2bdb93e4573fa49"


  def self.authenticate

    Instagram.configure do |config|

      config.client_id = "3f49652e724142b0a049fbfd275efff1"

      config.client_secret = "c2af7abadc3044f18497c1bd6a7e963f"

    end
    response = Instagram.get_access_token("2465d3a0ff2b43838755a3fdee17b379", :redirect_uri => CALLBACK_URL)
    token = response.access_token

  end


  def self.obtener_promociones

    client = Instagram.client(:access_token => $token)

    tags = client.tag_search('promociones')

    for media_item in client.tag_recent_media(tags[0].name)

    texto= media_item.caption.text


      if texto.include? "sku"
        datos=[]
        texto
        result=texto.split("sku=")
        result1=result[1].split("precio=")
        datos<<result1[0].strip()
        result2=result1[1].split("codigo=")
        datos<<result2[0].strip
        result_aux=result2[1].split
        datos<<result_aux[0].strip

        # validar que el codigo no haya sido ingresado.
        promocion_codigo= Promocion.find_by_codigo(datos[2])

        if promocion_codigo.nil?
          Promocion.create(sku: datos[0],precio: datos[1], codigo: datos[2])
        end
        

      end

    end

    end
end
