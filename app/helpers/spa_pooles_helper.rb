module SpaPoolesHelper

	def get_pool_volume(params,property)
		if params[:pool_shape] == "rectangular"
		  return (params[:length].to_f*params[:width].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		elsif params[:pool_shape] == "round"
			return (3.14*((params[:diameter].to_f*params[:diameter].to_f)/4)*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		elsif params[:pool_shape] == "oval"
			return (params[:length].to_f*params[:width].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*5.9) rescue "0.0"
		elsif params[:pool_shape] == "kidney"
			return (0.45*(params[:width].to_f+params[:width2].to_f)*params[:length].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		end
	end

	def get_spa_volume(params,property)
		if params[:spa_shape] == "rectangular"
		  return (params[:length].to_f*params[:width].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		elsif params[:spa_shape] == "round"
			return (3.14*((params[:diameter].to_f*params[:diameter].to_f)/4)*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		elsif params[:spa_shape] == "oval"
			return (params[:length].to_f*params[:width].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*5.9) rescue "0.0"
		elsif params[:spa_shape] == "kidney"
			return (0.45*(params[:width].to_f+params[:width2].to_f)*params[:length].to_f*((params[:depth].to_f+params[:depth2].to_f)/2)*7.5) rescue "0.0"
		end
	end

end
