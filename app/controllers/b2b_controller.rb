class B2bController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new_user, :get_token]
  before_action :authenticate, except: [ :new_user, :get_token ]
  respond_to :json

  def authenticate(is_token)
    user_token = User.find_by(token: is_token).token
    authenticate_or_request_with_http_token do |token, options|
      token == user_token
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
        render json: {success: false, message: "error. Orden inválida"},status: :bad_request
      else
        pedido=Pedido.new
        pedido.sku = orden[0]["sku"]
        pedido.cantidad = orden[0]["cantidad"]
        pedido.precio_unitario = orden[0]["precioUnitario"]
        cliente = orden[0]["cliente"]
        pedido.direccion = Cliente.get_direccion(cliente)


        #cosa = Bodega.validar_pedido?(pedido)
        #render json: { success: false, message: cosa}, status: :internal_server_error

        if Bodega.validar_pedido?(pedido)
          render json: { success: true, message:  "La orden de compra ha procesada exitosamente."},status: :ok
        else
          render json: { success: false, message: "ups! tuvimos un problema"}, status: :internal_server_error
          # CONECTARSE A LA API DEL OTRO GRUPO
          #
          #
        end
      end
    else
      render json: {success: false, message: "error en los parametros"},status: :bad_request
    end
  end

#POST /b2b/order_accepted
def order_accepted
#   order_id = params["prder_id"]
#   if order_id.nil?
#     render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
#   else
#     #retornar un mensaje de que se aceptó

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este aceptada"}, status: :bad_request
end

#POST /b2b/order_canceled
def order_canceled
#   order_id = params["prder_id"]
#   if order_id.nil?
#     render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
#   else
#     #retornar un mensaje de que se canceló

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este cancelada"}, status: :bad_request
end

#POST /b2b/order_rejected
def order_rejected
#   order_id = params["prder_id"]
#   if order_id.nil?
#     render json: {success: false, message: "La orden de compra es requerida"}, status: :bad_request
#   else
#     #retornar un mensaje de que se rechazó

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request
end

#POST /b2b/invoice_paid
def invoice_created
#   invoice_id = params["invoice_id"]
#   if invoice_id.nil?
#     render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
#   else
#     #retornar un mensaje de que se rechazó

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request
end

#POST /b2b/invoice_paid
def invoice_paid
#   invoice_id = params["invoice_id"]
#   if invoice_id.nil?
#     render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
#   else
#     #retornar un mensaje de que se pago

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este pagada"}, status: :bad_request
end

#POST /b2b/invoice_rejected
def invoice_rejected
#   invoice_id = params["invoice_id"]
#   if invoice_id.nil?
#     render json: {success: false, message: "ID de factura requerido"}, status: :bad_request
#   else
#     #retornar un mensaje de que se rechazó

#   end

# rescue Exception => e
#   return render json: {success: false, message: "No se peude verificar que la orden este rechazada"}, status: :bad_request
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


def pval()
  #Defino el esquema tipo de JSON
  #Para obtener y crear usuario
  schema1= {
    "type" => "object",
    "required" =>["username","password"],
    "properties" =>{
      "username" =>{"type"=>"string"}
      "password" =>{"type"=>"string"}
    }
  }

  #Para notificar ordenes
    schema2= {
    "type" => "object",
    "required" =>["order_id"],
    "properties" =>{
      "order_id" =>{"type"=>"string"}
    }
  }

    #Para obtener y crear usuario
  schema3= {
    "type" => "object",
    "required" =>["order_id","client","proveedor","sku","date_delivery","quantity","price"],
    "properties" =>{
      "order_id" =>{"type"=>"string"}
      "client" =>{"type"=>"string"}
      "proveedor" =>{"type"=>"string"}
      "sku" =>{"type"=>"string"}
      "date_delivery" =>{"type"=>"string"}
      "quantity" =>{"type"=>"integer"}
      "price" =>{"type"=>"integer"}
    }
  }

  JSON::Validator.validate(schema, "lo que hay que validar")

  
end




end