class OrdenCompraController < ApplicationController
  def estado
  	$order_id = params["q"]
  end
end
