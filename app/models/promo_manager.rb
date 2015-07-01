class PromoManager < ActiveRecord::Base

  CALLBACK_URL = "http://integra8.ing.puc.cl/"

  $token = "41805320.3f49652.296c36cc778d466fa2bdb93e4573fa49"


  def self.authenticate_instagram

    Instagram.configure do |config|

      config.client_id = "3f49652e724142b0a049fbfd275efff1"

      config.client_secret = "c2af7abadc3044f18497c1bd6a7e963f"

    end
    response = Instagram.get_access_token("2465d3a0ff2b43838755a3fdee17b379", :redirect_uri => CALLBACK_URL)
    token = response.access_token

  end


  def self.obtener_instagram
    PromoManager.obtener_promocion_instagram_aux
    PromoManager.obtener_promociones_instagram_aux
  end

  def self.obtener_promocion_instagram_aux
    client = Instagram.client(:access_token => $token)

    tags = client.tag_search('promocion')

    for media_item in client.tag_recent_media(tags[0].name)

      texto= media_item.caption.text


      if texto.include? "sku"
        puts 'ENCONTREEEEEEEEEEEEEEEEEEEEEEEE UNA'
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
          #ver que sea one of us
          if datos[0].eql? "25" or datos[0].eql? "43" or datos[0].eql? "45" or datos[0].eql? "46" or datos[0].eql? "48"
            Promocion.create(sku: datos[0],precio: datos[1], codigo: datos[2],inicio: Date.today, fin: Date.tomorrow)
          end
        end



      end

    end
  end


  def self.obtener_promociones_instagram_aux

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
          #ver que sea one of us
          if datos[0].eql? "25" or datos[0].eql? "43" or datos[0].eql? "45" or datos[0].eql? "46" or datos[0].eql? "48"
            Promocion.create(sku: datos[0],precio: datos[1], codigo: datos[2],inicio: Date.today, fin: Date.tomorrow)
          end
        end



      end

    end




  end


  def self.leer_cola

    url_desarrollo= 'amqp://oegxeowe:tGioVH7GaxxnufFc2AWq54FMetkPJcWk@owl.rmq.cloudamqp.com/oegxeowe'


    conn = Bunny.new(url_desarrollo)
    conn.start

    ch   = conn.create_channel
    q    = ch.queue("ofertas",:durable => false)


    q.subscribe(:block => true) do |delivery_info, properties, body|

      parsear_promocion body

      # cancel the consumer to exit
      conn.close
    end



  end


  def self.parsear_promocion body

    puts " [x] Received #{body}"
    promo= JSON.parse(body)

    puts promo["sku"]
    puts promo["precio"]
    inicio = Date.strptime("#{(promo["inicio"]/1000)}","%s")
    puts inicio
    fin = Date.strptime("#{(promo["fin"]/1000)}","%s")
    puts fin

    if promo["sku"].eql? "25" or promo["sku"].eql? "43" or promo["sku"].eql? "45" or promo["sku"].eql? "46" or promo["sku"].eql? "48"
      nueva_promo = Promocion.create(sku: promo["sku"],precio: promo["precio"],inicio: inicio, fin: fin)
      PromoManager.publicar_twitter nueva_promo
    end


  end

  def self.publicar_cola
    url_desarrollo= 'amqp://rygvhvjb:eUeNkPiomIPMa-70_7PjMPRfbHZPN7K0@owl.rmq.cloudamqp.com/rygvhvjb'


    conn = Bunny.new(url_desarrollo)
    conn.start

    ch   = conn.create_channel
    q    = ch.queue("ofertas", durable: false)

    ch.default_exchange.publish('{"sku":"46","precio":5215,"inicio":1435542298432,"fin":1435553098432}',:routing_key => q.name)


    conn.close


  end


  #
  def self.obtener_promo_dia sku

    promos = Promocion.where("sku = '#{sku}' AND inicio <='#{Date.today}' AND fin >= '#{Date.today}' AND codigo != 'nil'")
    #.and("fin >= '#{Date.today}'")

    begin
    promos.sort_by(&:precio)
   x= promos.first.precio.to_f

  rescue
    return 1000000
  end

  return x


end


def self.publicar_twitter promocion

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "UzcDCxjqnVOHYSERTyRfNTKLP"
    config.consumer_secret     = "fGU1IDnJsf6wvXGJCjD7YorIC3wYtKiEIvxaOb1WdwSvendxLQ"
    config.access_token        = "3347994251-QaDP1uLU7oxdPZ01sU1vf6yO4kmznmtullF4FG3"
    config.access_token_secret = "ocOdkbzKrcA39SXSGVeCUklzoAVPuojmnX9JcUt7V8cBd"
  end


  case promocion.sku.to_s
    when "25"
      texto="Aprovecha esta nueva promoción del mejor azucar del mercado por solo $#{promocion.precio}, solo hasta #{promocion.fin}!!"
       url= client.update_with_media(texto, File.new("app/assets/images/azucar.png")).uri.to_s

    when "43"
      texto="Necesitas nuevos muebles? quizas una casa de perro? Apurate y llevate toda la madera que quieras
por solo $#{promocion.precio}!!"
      url=client.update_with_media(texto, File.new("app/assets/images/madera.jpg")).uri.to_s
    when "45"
      texto="Celulosa a solo $#{promocion.precio}. Promoción válida hasta #{promocion.fin}."
      url=client.update_with_media(texto, File.new("app/assets/images/celulosa.png")).uri.to_s
    when "46"
      texto="Adicto al chocolate? Ven a disfrutar con nosotros.. Chocolate por sólo $#{promocion.precio}!!"
      url=client.update_with_media(texto, File.new("app/assets/images/chocolate.jpg")).uri.to_s
    when "48"
      texto="La mejor pasta de sémola del mercado rebajada a $#{promocion.precio}. Stock limitado, apúrate!"
     url= client.update_with_media(texto, File.new("app/assets/images/pastadesemola.png")).uri.to_s

  end

  #guardar url de tweet en la base de datos del ESB
  postear_esb url




end


  def self.postear_esb url



    result = HTTParty.get("http://chiri.ing.puc.cl/integra8/?accion=ingresar&url=#{url}&grupo=8")

    case result.code

      when 200
        return result.to_s
      when 202
        return result.to_s

      else

        Rails.logger.info("error en la conexion")
        return result.to_s
    end

  end




end