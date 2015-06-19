class PromoManagerController < ApplicationController

  Instagram.configure do |config|
    config.client_id = "3f49652e724142b0a049fbfd275efff1"
    config.client_secret = "c2af7abadc3044f18497c1bd6a7e963f"
  end


  Instagram.authorize_url(:redirect_uri => CALLBACK_URL)

end