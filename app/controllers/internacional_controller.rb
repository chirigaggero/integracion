class InternacionalController < ApplicationController
	def ftp

		require 'net/sftp'

		# iniciamos la conexion al ftp
		Net::SFTP.start('chiri.ing.puc.cl', 'integra8', :password => 'M1yA.3$Zf') do |sftp|
			# Revisar pedidos que no tenemos
			sftp.dir.foreach("/Pedidos") do |entry|
				# obtenemos el id del pedido
				if entry.name.include?("pedido_") and entry.name.include?(".xml")
			    	order_id = entry.name
			    	order_id.slice! "pedido_"
			    	order_id.slice! ".xml"
				
				    if Pedido.find_by(order_id: order_id).nil?
				    	#no tenemos el pedido
						# leer pedido xml
						sftp.file.open("/Pedidos/pedido_#{order_id}.xml", "r") do |f|
							pedido_xml=""
							pedido_xml += f.gets
							pedido_xml += f.gets
							xml_doc = Nokogiri::XML(pedido_xml);

							if errors = xml_doc.errors.empty?
							    oc = xml_doc.xpath("/xml/Pedido/oc").text
							    cliente = xml_doc.xpath("/xml/Pedido/cliente").text
							    proveedor = xml_doc.xpath("/xml/Pedido/proveedor").text
							    sku = xml_doc.xpath("/xml/Pedido/sku").text
							    fechaEntrega = xml_doc.xpath("/xml/Pedido/fechaEntrega").text
							    cantidad = xml_doc.xpath("/xml/Pedido/cantidad").text
							    precioUnitario = xml_doc.xpath("/xml/Pedido/precioUnitario").text

							    if oc.empty? or cliente.empty? or proveedor.empty? or sku.empty? or fechaEntrega.empty? or cantidad.empty? or precioUnitario.empty?
									# pedido mal formado
								else
								    pedido = Pedido.new
								    pedido.order_id = oc
								    pedido.sku = sku
								    pedido.fechaEntrega = Date.strptime(fechaEntrega, '%m.%d.%Y')
								    pedido.direccion = Cliente.find_by(cliente_id: cliente).direccion
								    pedido.precio_unitario = precioUnitario
								    pedido.cantidad = cantidad

								    #pedido.save
									if Bodega.validar_pedido?(pedido)
										pedido.save
									end
							    end
							end
						end
				    else
				    	# Pedido ya procesado
				    	# no hacemos nada
				    end
				end
			end
		end
	end
end
