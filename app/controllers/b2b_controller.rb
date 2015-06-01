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
    username = params["username"]
    password = params["password"]

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

  def prueba
    header1 = {"Content-Type"=> "application/json"}
    orden = HTTParty.get("http://chiri.ing.puc.cl/atenea/obtener/123",:headers => header1)
    hola="hola"

    if !orden[0]["msg"].nil?
      render json: {success: false, message: "error. Orden inválida"},status: :bad_request
    else
      render json: { success: true, message:  "La orden de compra ha sido recibida exitosamente."},status: :ok
    end
  end

  #POST /b2b/new_order
  def new_order
    #el programa esta hecho para leer json
    #verifico que sea json
    respuesta = JSON.parse(request.body.read)
    order_id = respuesta["order_id"]

    if  !order_id.nil?
      header1 = {"Content-Type"=> "application/json"}
      orden = HTTParty.get("http://chiri.ing.puc.cl/atenea/obtener/#{order_id}",:headers => header1)

      if !orden[0]["msg"].nil?
        render json: {success: false, message: "Error, Orden invalida."},status: :bad_request
      else
        pedido=Pedido.new
        pedido.sku = orden[0]["sku"]
        pedido.cantidad = orden[0]["cantidad"]
        pedido.precio_unitario = orden[0]["precioUnitario"]
        cliente = orden[0]["cliente"]
        #pedido.direccion = Cliente.get_direccion(cliente)
        pedido.fechaEntrega = orden[0]["fechaEntrega"][0..9]
        pedido.cantidadDespachada = 0
        pedido.estado = 'creado'

        #cosa = Bodega.validar_pedido?(pedido)
        #render json: { success: false, message: cosa}, status: :internal_server_error

        if Bodega.validar_pedido?(pedido)
          pedido.save
          #conectarnos a api del otro grupo,especificamente a order_accepted
          #crear factura
          #conectaarse a api del otro grupo y entregarle factura
          render json: { success: true, message:  "La orden de compra ha sido recibida"},status: :ok
        else
          pedido.save
          #Pedido.delete(pedido)
          render json: { success: false, message: "No hay stock suficiente en nuestras bodegas"}, status: :internal_server_error
          # CONECTARSE A LA API DEL OTRO GRUPO
        end
      end
    else
      render json: {success: false, message: "Error en los parametros"},status: :bad_request
    end
  end

#POST /b2b/order_accepted
def order_accepted
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#POST /b2b/order_canceled
def order_canceled
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#POST /b2b/order_rejected
def order_rejected
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#POST /b2b/invoice_paid
def invoice_created
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#POST /b2b/invoice_paid
def invoice_paid
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#POST /b2b/invoice_rejected
def invoice_rejected
  render json: {success: false, message: "No implementado"}, status: :internal_server_error
end

#GET /b2b/bank_account
def bank_account
  render json: {success: true, account: Banco.get_account}, status: :ok
end


#validador de json
def valid_json?()
  respuesta = JSON.parse(request.body.read)
  if respuesta["order_id"]
     true
  else
     false
  end
end


end