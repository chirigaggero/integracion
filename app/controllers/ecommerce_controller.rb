class EcommerceController < ApplicationController

  def products
    @precio = {}
    @precio_promocion = {}
    @promo = {}

    @precio["azucar"] = obtenerPrecio 25
    @precio["madera"] = obtenerPrecio 43
    @precio["celulosa"] = obtenerPrecio 45
    @precio["chocolate"] = obtenerPrecio 46
    @precio["pastadesemola"] = obtenerPrecio 48


    @precio_promocion["azucar"] = PromoManager.obtener_promo_dia 25
    if @precio_promocion["azucar"] < @precio["azucar"]
      @promo["azucar"] = true
    else
      @promo["azucar"] = false
    end
    @precio_promocion["madera"] = PromoManager.obtener_promo_dia 43
    if @precio_promocion["madera"] < @precio["madera"]
      @promo["madera"] = true
    else
      @promo["madera"] = false
    end
    @precio_promocion["celulosa"] = PromoManager.obtener_promo_dia 45
    if @precio_promocion["celulosa"] < @precio["celulosa"]
      @promo["celulosa"] = true
    else
      @promo["celulosa"] = false
    end
    @precio_promocion["chocolate"] = PromoManager.obtener_promo_dia 46
    if @precio_promocion["chocolate"] < @precio["chocolate"]
      @promo["chocolate"] = true
    else
      @promo["chocolate"] = false
    end
    @precio_promocion["pastadesemola"] = PromoManager.obtener_promo_dia 48
    if @precio_promocion["pastadesemola"] < @precio["pastadesemola"]
      @promo["pastadesemola"] = true
    else
      @promo["pastadesemola"] = false
    end

    message = ""
  	if params[:product] and params[:quantity]
  		if params[:product]=="azucar"
        sku = ProductInfo.find_by(product_id: "azucar").sku
        if params[:quantity].to_i == 0
          message = "Debes ingresar un numero entero mayor a cero."
        elsif Bodega.cantidad_total_sku(sku) < params[:quantity].to_i
          message = "No hay stock suficiente de este producto"
        else
          session[:azucar]=params[:quantity]
        end
  		end
  		if params[:product]=="madera"
        sku = ProductInfo.find_by(product_id: "madera").sku
        if params[:quantity].to_i == 0
          message = "Debes ingresar un numero entero mayor a cero."
        elsif Bodega.cantidad_total_sku(sku) < params[:quantity].to_i
          message = "No hay stock suficiente de este producto"
        else
          session[:madera]=params[:quantity]
        end
  		end
  		if params[:product]=="celulosa"
        sku = ProductInfo.find_by(product_id: "celulosa").sku
        if params[:quantity].to_i == 0
          message = "Debes ingresar un numero entero mayor a cero."
        elsif Bodega.cantidad_total_sku(sku) < params[:quantity].to_i
          message = "No hay stock suficiente de este producto"
        else
          session[:celulosa]=params[:quantity]
        end
  		end
  		if params[:product]=="chocolate"
        sku = ProductInfo.find_by(product_id: "chocolate").sku
        if params[:quantity].to_i == 0
          message = "Debes ingresar un numero entero mayor a cero."
        elsif Bodega.cantidad_total_sku(sku) < params[:quantity].to_i
          message = "No hay stock suficiente de este producto"
        else
          session[:chocolate]=params[:quantity]
        end
  		end
  		if params[:product]=="pastadesemola"
        sku = ProductInfo.find_by(product_id: "pastadesemola").sku
        if params[:quantity].to_i == 0
          message = "Debes ingresar un numero entero mayor a cero."
        elsif Bodega.cantidad_total_sku(sku) < params[:quantity].to_i
          message = "No hay stock suficiente de este producto"
        else
          session[:pastadesemola]=params[:quantity]
        end
  		end
      if message != ""
        flash[:notice] = message
      else
  		  flash[:notice] = "Se ha agragado exitosamente al carrito de compras. (producto: "+params[:product] + ", cantidad:"+params[:quantity]+")"
  	  end
    end
  end

  def shoppingcart
    @precio_azucar = obtenerPrecio 25
    @precio_madera = obtenerPrecio 43
    @precio_celulosa = obtenerPrecio 45
    @precio_chocolate = obtenerPrecio 46
    @precio_pastadesemola = obtenerPrecio 48


    @precio_promocion_azucar = PromoManager.obtener_promo_dia 25
    if @precio_promocion_azucar < @precio_azucar
      @promo_azucar = true
    else
      @promo_azucar = false
    end
    @precio_promocion_madera = PromoManager.obtener_promo_dia 43
    if @precio_promocion_madera < @precio_madera
      @promo_madera = true
    else
      @promo_madera = false
    end
    @precio_promocion_celulosa = PromoManager.obtener_promo_dia 45
    if @precio_promocion_celulosa < @precio_celulosa
      @promo_celulosa = true
    else
      @promo_celulosa = false
    end
    @precio_promocion_chocolate = PromoManager.obtener_promo_dia 46
    if @precio_promocion_chocolate < @precio_chocolate
      @promo_chocolate = true
    else
      @promo_chocolate = false
    end
    @precio_promocion_pastadesemola = PromoManager.obtener_promo_dia 48
    if @precio_promocion_pastadesemola < @precio_pastadesemola
      @promo_pastadesemola = true
    else
      @promo_pastadesemola = false
    end

    # calculamos el total
    total = 0
    if session[:azucar]
      precio = @promo_azucar ? @precio_promocion_azucar : @precio_azucar
      cantidad = session[:azucar].to_i
      total_azucar = precio*cantidad
    else
      total_azucar = 0
    end
    if session[:madera]
      precio = @promo_madera ? @precio_promocion_madera : @precio_madera
      cantidad = session[:madera].to_i
      total_madera = precio*cantidad
    else
      total_madera = 0
    end
    if session[:celulosa]
      precio = @promo_celulosa ? @precio_promocion_celulosa : @precio_celulosa
      cantidad = session[:celulosa].to_i
      total_celulosa = precio*cantidad
    else
      total_celulosa = 0
    end
    if session[:chocolate]
      precio = @promo_chocolate ? @precio_promocion_chocolate : @precio_chocolate
      cantidad = session[:chocolate].to_i
      total_chocolate = precio*cantidad
    else
      total_chocolate = 0
    end
    if session[:pastadesemola]
      precio = @promo_pastadesemola ? @precio_promocion_pastadesemola : @precio_pastadesemola
      cantidad = session[:pastadesemola].to_i
      total_pastadesemola = precio*cantidad
    else
      total_pastadesemola = 0
    end

    $total_compra = total_azucar + total_madera + total_celulosa + total_chocolate + total_pastadesemola          

  	if params[:destroy]
  		session[:azucar]=nil
  		session[:madera]=nil
  		session[:celulosa]=nil
  		session[:chocolate]=nil
  		session[:pastadesemola]=nil
      $total_compra = 0
  	end
  end

  def checkout
    # generamos boleta
    url = "http://chiri.ing.puc.cl:8080/Jboss/integra8/Factura/boleta/"
    headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
    body = {"proveedor" => "556489daefb3d7030091bab1", "cliente" => "CLIENTE", "total" => $total_compra}
    result = HTTParty.put(url, :headers => headers, :body => body.to_json)
    id = result["_id"]
    url = "http://chiri.ing.puc.cl/banco/pagoenlinea?callbackUrl=http%3A%2F%2Fintegra8.ing.puc.cl%2Fecommerce%2Fok&cancelUrl=http%3A%2F%2Fintegra8.ing.puc.cl%2Fecommerce%2Ffail&boletaId=#{id}"
    redirect_to url
  end

  def ok
  end

  def fail
  end

  def obtenerPrecio sku
    url = "http://chiri.ing.puc.cl/integra8/?accion=leer&sku=#{sku}"
    result = HTTParty.get(url)

    ultimo_precio = result[0]
    result.each do |precio|
      if (precio["Fecha_Inicio"] > ultimo_precio["Fecha_Inicio"] && precio["Fecha_Inicio"] <= Date.today.to_s)
        ultimo_precio = precio
      end
    end

    return ultimo_precio["Precio"]
  end

end
