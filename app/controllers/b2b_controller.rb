class B2bController < ApplicationController
  # GET /b2b/documentation
  respond_to :json

  def documentation
  end

  # POST /b2b/new_user
  def new_user

    user = params["username"]
    password = params["password"]

    if user.nil? or password.nil?
      render json: {success: false, message: "El usuario y password no pueden estar en blanco."}, status: :bad_request
    else
      newuser = User.new({
                             username: user,
                             password: password,
                             password_confirmation: password
                         })
      newuser.save!
      render json: {success: true, message: "Su usuario ha sido creado exitosamente.", token: "dsvs"}, status: :created
    end
  end

  #POST /b2b/get_token
  def get_token
    if user.nil? or password.nil?
      render json: {success: false, message: "El usuario y contraseña requeridos"}, status: :bad_request
    else
      #retornar un token bueno

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que el usuario y la contraseña sean correctos"}, status: :bad_request
  end

  #POST /b2b/new_order
  def new_order
    #el programa esta hecho para leer json
    #verifico que sea json
    if valid_json(aux)
      order_id = params["order_id"]
      orden = HTTParty.GET("http://chiri.ing.puc.cl/atenea/obtener/#{order_id}")
      sku = orden[0]["Sku"]
      cantidad = orden[0]["Cantidad"]
      cliente = orden[0]["Cliente"]
      precio=orden[0]["Precio unitario"]
      direccion = Cliente.get_direccion()


      pedido=Pedidos.create(order_id, sku, cantidad, direccion)
      if Bodega.aceptar_pedido?(pedido)
        return Json(new { succes=true, message="La orden de compra ha sido recibida exitosamente." }), status :ok
      else
        #
        #
        # CONECTARSE A LA API DEL OTRO GRUPO
        #
        #
      end
      rescue Exception => e

      return render json: {success: false, message: "se requiere orden de compra"}, status: :bad_request

    end

  end


  #POST /b2b/order_accepted
  def order_accepted
    order_id = params["prder_id"]
    if order_id.nil?
      render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
    else
      #retornar un mensaje de que se aceptó

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este aceptada"}, status: :bad_request

  end

  #POST /b2b/order_canceled
  def order_canceled
    order_id = params["prder_id"]
    if order_id.nil?
      render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
    else
      #retornar un mensaje de que se canceló

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este cancelada"}, status: :bad_request

  end

  #POST /b2b/order_rejected
  def order_rejected
    order_id = params["prder_id"]
    if order_id.nil?
      render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
    else
      #retornar un mensaje de que se rechazó

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request


  end

  #POST /b2b/invoice_paid
  def invoice_created
    invoice_id = params["invoice_id"]
    if invoice_id.nil?
      render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
    else
      #retornar un mensaje de que se rechazó

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request

  end

  #POST /b2b/invoice_paid
  def invoice_paid
    invoice_id = params["invoice_id"]
    if invoice_id.nil?
      render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
    else
      #retornar un mensaje de que se pago

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este pagada"}, status: :bad_request

  end

  #POST /b2b/invoice_rejected
  def invoice_rejected
    invoice_id = params["invoice_id"]
    if invoice_id.nil?
      render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
    else
      #retornar un mensaje de que se rechazó

    end

  rescue Exception => e
    return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request


  end

  #validador de json
  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue Exception => e
      return false
    end
  end

end