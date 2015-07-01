class DashboardsController < ApplicationController
  def ventas
  end

  def nivel_servicio

  end

  def contable

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

  end

  def fabrica

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

    @twitter_azucar= Promocion.where("codigo ='nil' AND sku= '25'").count
    @twitter_madera= Promocion.where("codigo ='nil' AND sku= '43'").count
    @twitter_celulosa= Promocion.where("codigo ='nil' AND sku= '45'").count
    @twitter_choco= Promocion.where("codigo ='nil' AND sku= '46'").count
    @twitter_pastasemola= Promocion.where("codigo ='nil' AND sku= '48'").count




  end

  def grupos

  end


end

