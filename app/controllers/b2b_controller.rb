class B2bController < ApplicationController
  # GET /b2b/documentation
  respond_to :json

  def documentation
  end

  # POST /b2b/new_user
  def new_user
    username = params["username"]
    password = params["password"]

    if username.nil? or password.nil?
      render json: {success: false, message: "El usuario y password no pueden estar en blanco."}, status: :bad_request
    else
      if User.find_by(username:username)
        render json: {success: false, message: "El usuario ya ha sido creado, elige otro."}, status: :bad_request
      else
        user = User.new(username:username, password: password)
        user.save
        token = user.generate_token
        render json: {success: true, message: "Su usuario ha sido creado exitosamente.", token: token}, status: :created
      end
    end
  end

  #POST /b2b/get_token
  def get_token
    username = params["username"]
    password = params["password"]
    if username.nil? or password.nil?
      render json: {success: false, message: "El usuario y password no pueden estar en blanco."}, status: :bad_request
    else
      user = User.find_by(username: username).try(:authenticate, password)
      if user
        render json: {success: true, token: user.generate_token}, status: :ok
      else
        render json: {success: false, message: "Usuario o password invalidos."}, status: :bad_request
      end
    end


  end

  #POST /b2b/new_order
  def new_order
  #el programa esta hecho para leer json
  #verifico que sea json
  if valid_json(aux)
    order_id = params[:order_id]
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

      rescue Exception => e
      return Json(new { succes=false, message="This field is required." }), status :bad_request
    end
  end

  #POST /b2b/order_accepted
  def order_accepted
  end

  #POST /b2b/order_canceled
  def order_canceled
  end

  #POST /b2b/order_rejected
  def order_rejected
  end

  #POST /b2b/invoice_paid
  def invoice_paid
  end

  #POST /b2b/invoice_rejected
  def invoice_rejected
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