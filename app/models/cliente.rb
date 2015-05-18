class Cliente < ActiveRecord::Base

	def self.get_direccion(name)
    	direccion = Cliente.find_by(nombre: name).direccion
	end

end