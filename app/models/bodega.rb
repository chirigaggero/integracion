class Bodega < ActiveRecord::Base

  $id_grupo = 'grupo8'
  $key_bodega = 'DYzY6bQ3XxcyyPm'



  def self.id_bodegaDespacho
    return Bodega.where(tipo: 'despacho').almacen_id
  end


  def self.enviar_a_fabrica sku, transaccion, cantidad

    params = ["PUT",sku,cantidad,transaccion]
    security = Bodega.claveSha1(params)
    url = "http://integracion-2015-dev.herokuapp.com/bodega/fabrica/fabricar"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body= {

        "sku" => sku,
        "trxId" => transaccion,
        "cantidad" =>cantidad

    }

    result = HTTParty.put(url,:headers => header1,:body => body.to_json )
    return result.to_s


  end


  def self.revisar_stock
    # revisar si tenemos los productos que distribuimos.
    #sku,lote,precio
    datos_materiaprima=[['azucar',25,400,1588],['madera',43,1,1297],['celulosa',45,1,2646]]

    datos_chocolate=[['leche',7,251,1],['cacao',20,296,1],['azucar',25,269,1]]

    datos_semola=[['huevo',2,155,1],['semola',19,160,1],['sal',26,172,1]]

    skus_complejos = [['chocolate',46,800,1031,datos_chocolate],['pasta_semola',48,500,3256,datos_semola]]

    #revisar en las bodegas, y devolver cantidad. [primero las materias primas]
    datos_materiaprima.each do |nombre,sku,lote,precio|

      disponible =  cantidad_disponible_sku_reposicion sku
      #si es menor a 1000 Y no estamos pidiendo, tenemos que pedir a fabrica.

      pidiendo=false

      case nombre
        when 'azucar'
          if Transito.first.azucar
            pidiendo=true
          end
        when 'madera'
          if Transito.first.madera
            pidiendo=true
          end
        when 'celulosa'
          if Transito.first.celulosa
            pidiendo=true
          end
      end

      if disponible < 500

        if !pidiendo
        #cantidad requerida
        i=0
        while disponible+i*lote<500
          i+=1
        end

        requerido=i*lote
        #costo de la compra
        costo=precio*requerido
        #plata disponible en mi cuenta
        saldo= Banco.obtener_mi_saldo


        if saldo>=costo
          #hacer transferencia a fabrica, guardamos el id de la transferencia
          transferencia = Banco.pagar_a_fabrica costo
          #enviar a producir a la fabrica
          enviar_a_fabrica sku, transferencia, requerido


          case nombre
            when 'azucar'
              Transito.first[:azucar =>true]
            when 'madera'
              Transito.first[:madera =>true]
            when 'celulosa'
              Transito.first[:celulosa =>true]
          end
        else
          Rails.logger.info("No hay money para producir prod: #{sku}")
          break
        end

          end
      else
        case nombre
          when 'azucar'
            Transito.first[:azucar =>false]
          when 'madera'
            Transito.first[:madera =>false]
          when 'celulosa'
            Transito.first[:celulosa =>false]
        end

      end
    end

    ##revisar stock de productos complejos

    skus_complejos.each do |nombre,sku,lote,precio,datos|

      pidiendo=false

      case nombre
        when 'chocolate'
          if Transito.first.chocolate
            pidiendo=true
          end
        when 'pasta_semola'
          if Transito.first.pasta_semola
            pidiendo=true
          end
      end

      disponible =  cantidad_disponible_sku_reposicion sku

      if disponible < 500

        if !pidiendo

        i=0
        while disponible+i*lote<500
          i+=1
        end

        requerido=i*lote
        #costo de la compra
        costo=precio*requerido
        #plata disponible en mi cuenta
        saldo= Banco.obtener_mi_saldo



        if saldo>=costo

          ingredientes = true

          datos.each do |nombre,sku,lote,precio|
            ##chequear si tengo las materias primas en bodega
            disponible =  cantidad_disponible_sku_reposicion sku

            ##si no las tengo
            if disponible < i*lote

              ingredientes = false

              ver si estoy pidiendo

              pididendo = false

              case nombre
                when 'leche'
                  if Transito.first.leche
                    pidiendo=true
                  end
                when 'semola'
                  if Transito.first.semola
                    pidiendo=true
                  end
                when 'azucar'
                  if Transito.first.azucar
                    pidiendo=true
                  end
                when 'cacao'
                  if Transito.first.cacao
                    pidiendo=true
                  end
                when 'huevo'
                  if Transito.first.huevo
                    pidiendo=true
                  end
                when 'sal'
                  if Transito.first.sal
                    pidiendo=true
                  end

              end

              ##si no estoy pidiendo, tengo que mandar a pedir
              if(!pidiendo)
              ##crearorden de compra y enviarlo al grupo
              order_id = OcManager.crear_orden sku, i*lote,precio
              CompraB2B.pedir order_id,sku

              case nombre
                when 'leche'
                  Transito.first[:leche =>true]
                when 'cacao'
                  Transito.first[:cacao =>true]
                when 'azucar'
                  Transito.first[:azucar=>true]
                when 'huevo'
                  Transito.first[:huevo =>true]
                when 'semola'
                  Transito.first[:semola=>true]
                when 'sal'
                  Transito.first[:sal =>true]
              end
                ##pagar, factura?
              end
            else

              case nombre
                when 'leche'
                  Transito.first[:leche =>false]
                when 'cacao'
                  Transito.first[:cacao =>false]
                when 'azucar'
                  Transito.first[:azucar=>false]
                when 'huevo'
                  Transito.first[:huevo =>false]
                when 'semola'
                  Transito.first[:semola=>false]
                when 'sal'
                  Transito.first[:sal =>false]
              end

          end
          end

          if(ingredientes)
            ##si tenemos todos los ingredientes hay que moverlos a despacho
            id_normal1 = Bodega.first.almacen_id
            id_normal2 = Bodega.second.almacen_id
            id_recepcion = Bodega.third.almacen_id


            #mandar cada ingrediente a despacho
            datos.each do |nombre,sku,lote,precio|

              Bodega.first(2)[0..1].each do | almacen |

                params = ["GET", almacen.almacen_id]
                security = claveSha1(params)

                url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
                header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

                prod_almacen = almacen.get_cantidad_total(url,header1,sku)


                i*lote=a_mover

                while(prod_almacen>0 and a_mover>0)

                  id_producto = obtener_id_producto(almacen.almacen_id, sku)
                  mover_producto(id_producto, id_despacho)
                  #mover a almacen de despacho
                      prod_almacen-= 1
                      a_mover-= 1

                end

                if a_mover == 0
                  break
                end

                  end

            end

            ##pagar a fabrica
            ##producir
              ##sacar todos los prods de cada bodega


          #hacer transferencia a fabrica, guardamos el id de la transferencia
          transferencia = Banco.pagar_a_fabrica costo
          #enviar a producir a la fabrica
          enviar_a_fabrica sku, transferencia, requerido
          end

        else
          Rails.logger.info("No hay money para producir prod: #{sku}")
          break
        end
        end

        else

          case nombre
            when 'azucar'
              Transito.first[:azucar =>true]
            when 'madera'
              Transito.first[:madera =>true]
            when 'celulosa'
              Transito.first[:celulosa =>true]
          end
        end
        end

  end





  # Con un almacen id y sku obtenemos el primer producto disponible.
  def self.obtener_producto(almacen_id,pedido)

    params = ["GET",almacen_id,pedido.sku]
    security = Bodega.claveSha1(params)

    url = "http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{pedido.sku}&limit=1"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

    result = HTTParty.get(url,:headers => header1 )

    ##result tiene que ser LA repueat valida, no se como hacer esta verificacion pero
    ##vamos a asumir que si no es nula entonces est� bien.

    if !result.nil?
      contador=0
      ##pedidos=Pedido.first(Pedido.count-1)
      result.each do |item|

        #no es necesario, pero lo voy a dejar.

        prod = Producto.create(prod_id: item["_id"])
        pedido.productos<<prod

        return prod

      end
    end

  end




  ##asigna id de productos a un pedido.
  def armar_pedido?(pedido)
    ##conectarse a un almacen
    prods_necesitados=pedido.cantidad

    Bodega.first(4)[0..3].each do | almacen |

      prods_necesitados-=crear_prods(almacen.id,pedido,prods_necesitados)

      if prods_necesitados.equal?(0)
        return true
      end
    end
    return false
  end




  # Obtenemos la cantidad total disponible de productos de un sku
  def get_cantidad_total(url,header1,sku)
    cantidad=0
    result = HTTParty.get(url,:headers => header1 )
    #tiene que ser si la respuesta es valida, no se si es la forma. REVISAR
    case result.code

      when 200
        result.each do |item|
          if Integer(item["_id"])==sku
            cantidad+=Integer(item["total"])
          end
        end

      else
        Rails.logger.info("error en la conexion")
        return -10
    end
    return cantidad
  end

  # Encripta en sha1 base 64
  def self.claveSha1(params)
    if params.kind_of?(Array)
      to_hash = params.join("")
    else
      to_hash=params
    end

    aux = OpenSSL::HMAC.digest('sha1',$key_bodega, to_hash)
    security = Base64.encode64("#{aux}")
    security[0..-2]
  end

  # Metodo que valida si hay productos en bodega para satisfacer el pedido - es el encargado de llamar a los otros metodos
  def self.validar_pedido?(pedido)


    disponible = cantidad_disponible_sku_pedido pedido

    ##si la cantidad es menor a la diferencia entre el total y lo usado, se acepta.
    if pedido.cantidad<=disponible
      true
    else
      false
    end
  end

  ##obtener la cantidad disponible para efectos de reposicion
  def self.cantidad_disponible_sku_reposicion sku

    total = 0
    usado = 0

    #se itera sobre las primeras 4 bodegas
    Bodega.first(4)[0..3].each do | almacen |


      params = ["GET", almacen.almacen_id]
      security = claveSha1(params)


      url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
      header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

      ##obtenemos la cantidad total de productos con sku='sku' del almacen
      resultado = almacen.get_cantidad_total(url,header1,sku)
      #se suma lo obtenido al total
      total+=resultado
    end

    ##obtenemos lo usado por todos los pedidos
    pedidos = Pedido.all
    pedidos.each do |pedidox|
      if pedidox.sku.equal? sku
        #se suma la cantidad del pedido
        usado+=pedidox.cantidad
      end
    end

    return total-usado

  end

  ##obtener la cantidad disponible para efectos de validar pedido
  def self.cantidad_disponible_sku_pedido pedido
    sku=pedido.sku
    total=0
    usado=0
    #se itera sobre las bodegas normales
    Bodega.first(2)[0..1].each do | almacen |
      params = ["GET", almacen.almacen_id]
      security = claveSha1(params)


      url = "http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=" + almacen.almacen_id
      header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

      ##obtenemos la cantidad total del almacen
      resultado = almacen.get_cantidad_total(url,header1,sku)
      total += resultado
    end

    ##obtenemos lo usado por pedidos anteriores
    pedidos = Pedido.first(Pedido.count-1)[0..Pedido.count-2]
    pedidos.each do |pedidox|
      if pedidox.sku.equal? pedido.sku
        usado+=pedidox.cantidad
      end
    end

    return total-usado

  end




  #metodo que verifica que pedidos deben ser despachados "hoy" y los manda a despachar
  def despachar_pedidos_de_hoy

    pedidos = Pedido.where(fechaEntrega: DateTime.now.strftime("%Y-%m-%d")).or(estado: 'pendiente')

    pedidos.each do |pedido|

      pedido.despachar

    end

  end


  def self.vaciar_recepcion

    #datos a utilizar
    id_normal1 = Bodega.first.almacen_id
    id_normal2 = Bodega.second.almacen_id
    id_recepcion = Bodega.third.almacen_id

    capacidad_normal1 = capacidad_disponible(id_normal1)
    capacidad_normal2 = capacidad_disponible(id_normal2)

    #ver si el almacen de recepcion tiene productos
    skus = skus_de_almacen(id_recepcion)


    #para cada sku con stock tomar un id y moverlo
    skus.each do |item|

      id_producto = obtener_id_producto(id_recepcion, item)

      while !id_producto.nil?

        if capacidad_normal1 > 0
          mover_producto(id_producto, id_normal1)
          capacidad_normal1 -=1

        else capacidad_normal2 > 0
        mover_producto(id_producto, id_normal2)
        capacidad_normal2 -=1

        end

        id_producto = obtener_id_producto(id_recepcion, item)
      end

    end

  end



  #retorna un arreglo con los sku y cantidad de cada almacen
  def self.skus_de_almacen(almacen_id)

    #conexion y respuesta
    params = ["GET", almacen_id]
    security = Bodega.claveSha1(params)

    url="http://integracion-2015-dev.herokuapp.com/bodega/skusWithStock?almacenId=#{almacen_id}"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

    result = HTTParty.get(url,:headers => header1 )

    skus = []

    result.each do |listaSku|
      skus.append listaSku["_id"]
    end

    return skus

  end

  #retorna la capacidad disponible del almacen
  def self.capacidad_disponible(almacen_id)

    #conexion y respuesta
    params = ["GET"]
    security = Bodega.claveSha1(params)

    url = "http://integracion-2015-dev.herokuapp.com/bodega/almacenes"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

    result = HTTParty.get(url,:headers => header1 )

    #Buscar el almacen dentro de la respuesta y retornar la capacidad disponible
    capacidad = 0

    result.each do |almacenes|

      if almacenes["_id"] == almacen_id
        capacidad = almacenes["totalSpace"]-almacenes["usedSpace"]
      end

    end

    return capacidad

  end

  #devuelve UN id de un producto en almacen
  def self.obtener_id_producto(almacen_id, sku)

    params = ["GET",almacen_id, sku]
    security = Bodega.claveSha1(params)

    url = "http://integracion-2015-dev.herokuapp.com/bodega/stock?almacenId=#{almacen_id}&sku=#{sku}&limit=1"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}

    result = HTTParty.get(url,:headers => header1 )

    if !result.empty?
      result.each do |item|
        return item["_id"]
      end
    else
      return nil
    end
  end

  #mueve un producto de un almacen a otro
  def self.mover_producto(producto_id, almacen_id)

    params = ["POST",producto_id, almacen_id]
    security = Bodega.claveSha1(params)

    url = "http://integracion-2015-dev.herokuapp.com/bodega/moveStock"
    header1 = {"Content-Type"=> "application/json","Authorization" => "INTEGRACION grupo8:#{security}"}
    body = 	{
        "productoId" => producto_id,
        "almacenId" => almacen_id
    }

    result = HTTParty.post(url,:headers => header1,:body=>body.to_json)

    case result.code
      when 200
        true
      else
        false
    end
  end


  def self.cambiar_clave(nueva_clave)
    $key_bodega = nueva_clave
  end



end

