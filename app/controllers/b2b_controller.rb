class B2bController < ApplicationController
  # GET /b2b/documentation
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

  #POST /b2b/new_order
  def new_order
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
end