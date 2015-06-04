class B2bController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new_user, :get_token]
  before_action :authenticate, except: [ :new_user, :get_token, :documentation ]
  respond_to :json

  def authenticate
    if request.headers.include?('HTTP_AUTHORIZATION')
      token = request.headers["HTTP_AUTHORIZATION"].from(6) # Authorization Token #token => "Token " => 6 characters
      if User.find_by(token: token).nil?
        render json: {success: false, message: "Token Invalido."}, status: :unauthorized
      else
        if User.find_by(token: token).token_expired?
          render json: {success: false, message: "Token Expirado.", token: token}, status: :unauthorized
        end
      end
    else
      render json: {success: false, message: "No Token."}, status: :unauthorized
    end
  end

  # GET /b2b/documentation
  def documentation
  end

  # POST /b2b/new_user
  def new_user
    respuesta = JSON.parse(request.body.read)
    username = respuesta["username"]
    password = respuesta["password"]

    if username.nil? or password.nil?
      render json: {success: false, message: "El usuario y password no pueden estar en blanco."}, status: :bad_request
    else
      if User.find_by(username: username)
        render json: {success: false, message: "El usuario ya ha sido creado, elige otro."}, status: :bad_request
      else
        user = User.new(username: username, password: password)
        user.save
        token = user.generate_token
        render json: {success: true, message: "Su usuario ha sido creado exitosamente.", token: token}, status: :created
      end
    end

    rescue
      render json: {success: false, message: "JSON Malformado."}, status: :bad_request
  end

  #POST /b2b/get_token
  def get_token
    respuesta = JSON.parse(request.body.read)
    username = respuesta["username"]
    password = respuesta["password"]

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

    rescue
      render json: {success: false, message: "JSON Malformado."}, status: :bad_request
  end

  #PUT /b2b/new_order
  def new_order
    respuesta = JSON.parse(request.body.read)
    order_id = respuesta["order_id"]
    bodega_id = respuesta["bodega_id"]

    if order_id.nil? or bodega_id.nil?
      render json: {success: false, message: "Los parametros order_id y bodega_id no pueden estar en blanco."}, status: :bad_request
    else
      # consultamos al sistema de ordenes de compra
      headers = {"Content-Type"=> "application/json"}
      orden = HTTParty.get("http://chiri.ing.puc.cl/atenea/obtener/#{order_id}",:headers => headers)
      # guardamos pedido
      pedido=Pedido.new
      pedido.sku = orden[0]["sku"]
      pedido.cantidad = orden[0]["cantidad"]
      pedido.precio_unitario = orden[0]["precioUnitario"]
      pedido.fechaEntrega = orden[0]["fechaEntrega"][0..9]
      pedido.cantidadDespachada = 0
      pedido.direccion = bodega_id
      pedido.estado = "creado"
      # identificamos al cliente
      cliente = orden[0]["cliente"].to_i
      
      #validamos el pedido para ver si lo podemos satisfacer
      if Bodega.validar_pedido?(pedido)
        pedido.save
        # informamos al grupo que la orden fue aceptada
        CompraB2B.aceptar_orden order_id, cliente
        # generamos factura y notificamos al grupo
        invoice_id = CompraB2B.generar_factura cliente
        CompraB2B.notificar_factura invoice_id, cliente
        # enviamos el mensaje
        render json: { success: true, message:  "La orden de compra ha sido aceptada."}, status: :ok
      else
        # informamos al grupo que la orden fue rechazada
        CompraB2B.rechazar_orden order_id, cliente
        # enviamos el mensaje
        render json: { success: false, message: "La orden de compra ha sido rechazada."}, status: :internal_server_error
      end
    end

    rescue
      render json: {success: false, message: "JSON Malformado."}, status: :bad_request
  end

  #POST /b2b/order_accepted
  def order_accepted
    render json: {success: true, message: "Gracias por avisar."}, status: :ok
  end

  #POST /b2b/order_canceled
  def order_canceled
    render json: {success: true, message: "Gracias por avisar."}, status: :ok
  end

  #POST /b2b/order_rejected
  def order_rejected
    #hay obtener el order id del json
    respuesta = JSON.parse(request.body.read)
    order_id = respuesta["order_id"]
    #chequear el sku de la orden de compra
    orden = OcManager.obtener_orden order_id
    sku= orden[0]["sku"]
    #cancelamos internamente el pedido que contabamos como "aceptado"
    Transito.cancelar_pedido sku

    #retornamos un json
    render json: {success: true, message: "Gracias por avisar"}, status: :ok
  end

  #POST /b2b/invoice_paid
  def invoice_created
    render json: {success: false, message: "Gracias por avisar."}, status: :ok
  end

  #POST /b2b/invoice_paid
  def invoice_paid
    render json: {success: false, message: "Gracias por avisar."}, status: :ok
  end

  #POST /b2b/invoice_rejected
  def invoice_rejected
    render json: {success: false, message: "Gracias por avisar."}, status: :ok
  end

  #GET /b2b/bank_account
  def bank_account
    render json: {success: true, account: Banco.get_account}, status: :ok
  end

end