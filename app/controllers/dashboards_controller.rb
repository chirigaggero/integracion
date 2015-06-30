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

  end

  def grupos

  end


end

