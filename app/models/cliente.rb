class Cliente < ActiveRecord::Base

	def self.get_direccion(id)
    	direccion = Cliente.find_by(cliente_id: id).direccion
	end

end