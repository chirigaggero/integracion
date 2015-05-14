class Cliente < ActiveRecord::Base



def self.get_direccion(name)

cliente=Cliente.find_by_name(name).direccion

end
