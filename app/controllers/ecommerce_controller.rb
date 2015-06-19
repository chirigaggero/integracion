class EcommerceController < ApplicationController

  def products
  	if params[:product] and params[:quantity]
  		if params[:product]=="azucar"
  			session[:azucar]=params[:quantity]
  		end
  		if params[:product]=="madera"
  			session[:madera]=params[:quantity]
  		end
  		if params[:product]=="celulosa"
  			session[:celulosa]=params[:quantity]
  		end
  		if params[:product]=="chocolate"
  			session[:chocolate]=params[:quantity]
  		end
  		if params[:product]=="pastadesemola"
  			session[:pastadesemola]=params[:quantity]
  		end

  		flash[:notice] = "Se ha agragado exitosamente al carrito de compras. (producto: "+params[:product] + ", cantidad:"+params[:quantity]+")"
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
  end
end
