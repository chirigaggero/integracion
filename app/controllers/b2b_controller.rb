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
  def valid_json?()
    respuesta = JSON.parse(request.body.read)
    if respuesta["order_id"]
      true
    else
      false
    end
  end

end