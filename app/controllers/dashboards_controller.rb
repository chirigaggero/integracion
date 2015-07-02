class DashboardsController < ApplicationController
  def ventas

  end

  def nivel_servicio

  end

  def contable


    @saldo= Banco.obtener_mi_saldo

    @transacciones=Transaccion.last 10


    @grupo_3= Transaccion.where(:destino => 'grupo3').count
    @grupo_4= Transaccion.where(:destino => 'grupo4').count
    @grupo_5= Transaccion.where(:destino => 'grupo5').count
    @grupo_6= Transaccion.where(:destino => 'grupo6').count
    @grupo_7= Transaccion.where(:destino => 'grupo7').count
    @fabrica =Transaccion.where(:destino => 'fabrica').count



  end

  def bodega

    almacenes_normales = Bodega.first(2)

    @disp=0
    @usado=0

    almacenes_normales.each do |almacen|


     @disp+= Bodega.capacidad_disponible almacen.almacen_id
     @usado += Bodega.espacio_usado almacen.almacen_id

    end

    @azucar= Bodega.cantidad_disponible_sku_reposicion 25
    @madera= Bodega.cantidad_disponible_sku_reposicion 43
    @celulosa=Bodega.cantidad_disponible_sku_reposicion 45
    @chocolate=Bodega.cantidad_disponible_sku_reposicion 46
    @pastasemola=Bodega.cantidad_disponible_sku_reposicion 48

    #obtener cantidad de cada producto


    recepcion= Bodega.find_by_tipo("recepcion")

    @disp_recepcion= Bodega.capacidad_disponible recepcion.almacen_id
    @usado_recepcion= Bodega.espacio_usado recepcion.almacen_id

  end


  def productos

    #filtrar pedidos por sku
    azucar= Pedido.where("sku= '25'")
    madera= Pedido.where("sku= '43'")
    celulo= Pedido.where("sku= '45'")
    choco= Pedido.where("sku= '46'")
    pastasemola= Pedido.where("sku= '48'")

    @ganancia_azucar=0
    @volumen_azucar=0
    @ftp_azucar=0
    @b2b_azucar=0
    @ecommerce_azucar=0
    azucar.each do |pedido|
      @ganancia_azucar+=pedido.precio_unitario*pedido.cantidad
      @volumen_azucar += pedido.cantidad

      if pedido.ftp
        @ftp_azucar+=1
      elsif !pedido.ftp and !pedido.ecommerce
        @b2b_azucar+=1
      else
        @ecommerce_azucar+=1
      end

    end

    @ganancia_madera=0
    @volumen_madera=0
    @ftp_madera=0
    @b2b_madera=0
    @ecommerce_madera=0
    madera.each do |pedido|
      @ganancia_madera+=pedido.precio_unitario*pedido.cantidad
      @volumen_madera += pedido.cantidad

      if pedido.ftp
        @ftp_madera+=1
      elsif !pedido.ftp and !pedido.ecommerce
        @b2b_madera+=1
      else
        @ecommerce_madera+=1
      end
    end

    @ganancia_celulo=0
    @volumen_celulo=0
    celulo.each do |pedido|
      @ganancia_celulo+=pedido.precio_unitario*pedido.cantidad
      @volumen_celulo += pedido.cantidad
    end

    @ganancia_choco=0
    @volumen_choco=0
    @ftp_choco=0
    @b2b_choco=0
    @ecommerce_choco=0
    choco.each do |pedido|
      @ganancia_choco+=pedido.precio_unitario*pedido.cantidad
      @volumen_choco += pedido.cantidad


      if pedido.ftp
        @ftp_choco+=1
      elsif !pedido.ftp and !pedido.ecommerce
        @b2b_choco+=1
      else
        @ecommerce_choco+=1
      end

    end

    @ganancia_pastasemola=0
    @volumen_pastasemola=0
    pastasemola.each do |pedido|
      @ganancia_pastasemola+=pedido.precio_unitario*pedido.cantidad
      @volumen_pastasemola += pedido.cantidad
    end


    #mercados del chocolate






  end

  def fabrica

    @azucar= Fabricacion.where("sku= '25'").sum('cantidad')
    @madera= Fabricacion.where("sku= '43'").sum('cantidad')
    @celulo= Fabricacion.where("sku= '45'").sum('cantidad')
    @choco= Fabricacion.where("sku= '46'").sum('cantidad')
    @pastasemola= Fabricacion.where("sku= '48'").sum('cantidad')


  end

  def ofertas
#1 promos instagram

    #cant chocolate, madera celulosa pasta semola azucar

    @insta_azucar= Promocion.where("codigo!='nil' AND sku= '25'").count
    @insta_madera= Promocion.where("codigo!='nil' AND sku= '43'").count
    @insta_celulosa= Promocion.where("codigo!='nil' AND sku= '45'").count
    @insta_choco= Promocion.where("codigo!='nil' AND sku= '46'").count
    @insta_pastasemola= Promocion.where("codigo!='nil' AND sku= '48'").count

#promos twitter
    @twitter_azucar= Promocion.where("codigo IS NULL AND sku= '25'").count
    @twitter_madera= Promocion.where("codigo IS NULL AND sku= '43'").count
    @twitter_celulosa= Promocion.where("codigo IS NULL AND sku= '45'").count
    @twitter_choco= Promocion.where("codigo IS NULL AND sku= '46'").count
    @twitter_pastasemola= Promocion.where("codigo IS NULL AND sku= '48'").count

  end

  def grupos

    @azucar= Bodega.cantidad_disponible_sku_reposicion 25
    @madera= Bodega.cantidad_disponible_sku_reposicion 43
    @celulosa=Bodega.cantidad_disponible_sku_reposicion 45
    @chocolate=Bodega.cantidad_disponible_sku_reposicion 46
    @pastasemola=Bodega.cantidad_disponible_sku_reposicion 48
    @huevo= Bodega.cantidad_disponible_sku_reposicion 2
    @sal= Bodega.cantidad_disponible_sku_reposicion 26
    @cacao=Bodega.cantidad_disponible_sku_reposicion 20
    @semola=Bodega.cantidad_disponible_sku_reposicion 19
    @leche=Bodega.cantidad_disponible_sku_reposicion 5



  end


end

