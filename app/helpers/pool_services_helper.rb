module PoolServicesHelper

	def pool_test_chlorine(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.chlorine.to_i.between?(pool_service.ch_low.to_i,pool_service.ch_high.to_i)
			return "true"
		else
			return "false"
		end
	end

	def pool_test_ph(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.ph_value.to_i.between?(pool_service.ph_low.to_i,pool_service.ph_high.to_i)
			return "true"
		else
			return "false"
		end
	end

	def pool_test_salt(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.salt_level.to_i.between?(pool_service.salt_low.to_i,pool_service.salt_high.to_i)
			return "true"
		else
			return "false"
		end
	end

	def pool_test_calcium(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.calcium_hardness.to_i.between?(pool_service.calcium_hardness_low.to_i,pool_service.calcium_hardness_high.to_i)
			return "true"
		else
			return "false"
		end
	end

	def pool_test_alkalinity(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.total_alkalinity.to_i.between?(pool_service.alkalinity_low.to_i,pool_service.alkalinity_high.to_i)
			return "true"
		else
			return "false"
		end		
	end

	def pool_range_chlorine(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.chlorine.to_i.between?(pool_service.ch_low.to_i,pool_service.ch_high.to_i)
			return ""
		else
			return "Correct Range: #{pool_service.ch_low.to_f} - #{pool_service.ch_high.to_f} "
		end
	end

	def pool_range_ph(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.ph_value.to_i.between?(pool_service.ph_low.to_i,pool_service.ph_high.to_i)
			return ""
		else
			return "Correct Range: #{pool_service.ph_low.to_f} - #{pool_service.ph_high.to_f} "
		end
	end

	def pool_range_salt(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.salt_level.to_i.between?(pool_service.salt_low.to_i,pool_service.salt_high.to_i)
			return ""
		else
			return "Correct Range: #{pool_service.salt_low.to_f} - #{pool_service.salt_high.to_f} "
		end
	end

	def pool_range_calcium(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.calcium_hardness.to_i.between?(pool_service.calcium_hardness_low.to_i,pool_service.calcium_hardness_high.to_i)
			return ""
		else
			return "Correct Range: #{pool_service.calcium_hardness_low.to_f} - #{pool_service.calcium_hardness_high.to_f} "
		end
	end

	def pool_range_alkalinity(pool_test,pool_service)
		if pool_test.id.blank? || pool_service.blank?
			return ""
		elsif pool_test.total_alkalinity.to_i.between?(pool_service.alkalinity_low.to_i,pool_service.alkalinity_high.to_i)
			return ""
		else
			return "Correct Range: #{pool_service.alkalinity_low.to_f} - #{pool_service.alkalinity_high.to_f} "
		end		
	end

end
