class Fabricacion < ActiveRecord::Base



  def self.envios_por_dia date


    total = Fabricacion.where(" fecha ='#{date}'").count

  end

end
