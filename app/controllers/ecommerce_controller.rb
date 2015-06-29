class EcommerceController < ApplicationController

  def products
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
  	if params[:destroy]
  		session[:azucar]=nil
  		session[:madera]=nil
  		session[:celulosa]=nil
  		session[:chocolate]=nil
  		session[:pastadesemola]=nil
  	end
  end

  def checkout
    # calculamos el total
    total = 0
    if session[:azucar]
      total += session[:azucar]
    end
    if session[:madera]
      total += session[:madera]
    end
    if session[:celulosa]
      total += session[:celulosa]
    end
    if session[:chocolate]
      total += session[:chocolate]
    end
    if session[:pastadesemola]
      total += session[:pastadesemola]
    end
    # generamos boleta
    url = "http://integra3.ing.puc.cl/b2b/get_token/"
    headers = {"Content-Type"=> "application/json", "Accept" => "application/json"}
    body = {"proveedor" => "grupo8", "cliente" => "CLIENTE", "total" => "TOTAL"}
    result = HTTParty.put(url, :headers => headers, :body => body.to_json)


    url = "http://chiri.ing.puc.cl/banco/pagoenlinea?callbackUrl=URL_OK&cancelUrl=URL_FAIL&boletaId=ID"

  end
end
