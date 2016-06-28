class Api::V1::ChemicalsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token	
	
	def chemical_add
		if current_user
			if current_user.user_type == "admin"
				check_used = current_user.chemical_items.where(:property_id=>nil).last
			else
				user =TeamMember.find_by_member_id(current_user.id)
				check_used = user.chemical_items.where(:property_id=>nil).last
			end
			if check_used
				render :status=>200, :json=>check_used.as_json
			else
				render :status=>200 ,:json=>{:status => "Chemical item are not store.."}
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def chemical_used
		if current_user
			if current_user.user_type == "admin"
				chemical_used = current_user.chemical_items.where(:property_id=>params[:property_id]).last
				chemical_used = current_user.chemical_items.new(chemical_params) if chemical_used.blank?
			else
				user =TeamMember.find_by_member_id(current_user.id)
				chemical_used = user.chemical_items.where(:property_id=>params[:property_id]).last
				chemical_used = user.chemical_items.new(chemical_params) if chemical_used.blank?
			end
				if !chemical_used.id.blank?
					chemical_used.update(chemical_params)
					render  :status=>200, :json=>chemical_used.as_json
				elsif chemical_used.save
					render  :status=>200, :json=>chemical_used.as_json
				else
					render :status=>200 ,:json=>{:status => "Chemical item are not found.."}
				end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def chemical_display
		if current_user
			if current_user.user_type == "admin"
				chemical_used = current_user.chemical_items.where(:property_id=>params[:property_id]).last
			else
				user =TeamMember.find_by_member_id(current_user.id)
				chemical_used = user.chemical_items.where(:property_id=>params[:property_id]).last
			end
			if chemical_used.blank?
				render :status=>200 ,:json=>{:status => "Chemical Not found.."}
			else
				render :status=>200, :json=>chemical_used.as_json
			end
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

  def test_result
  end

	def chemical_test
		if current_user
			pool_test= PoolTest.new(test_pool_params)
			if pool_test.save
				render :status=>200, :json=>pool_test.as_json
			else
				render :json=>{:status => "Pool Test not save some failure occur"}
			end
		else
			render :json=>{:status => "Failure Please Login"}
		end
	end

	def view_chemical_result
		if current_user
			pool_test=current_user.pool_tests.where(:property_id=>params[:property_id]).last
			if pool_test
				render :json=>{:status=>pool_test.as_json}
			else
				render :json=>{:status=>"Pool Test not found try again later"}
			end
		else
			render :json=>{:status => "Failure Please Login"}
		end
	end

	def chemical_test_range
		if current_user
			pool_service = current_user.pool_service 
			if pool_service
				render :json=>{:status=>pool_service.as_json}
			else
				render :json=>{:status=>"Chemial Test Range Not Found.."}
			end
		else
			render :json=>{:status =>"Failure Please Login"}
		end
	end

	def service_item
		if current_user
		  service_plans = current_user.service_plans.where(:property_id=>params[:property_id]).last
		  service_plan_id = Property.find(params[:property_id]).server_plan_id rescue ""
		  plan_service = ServicePlan.find(service_plan_id) rescue ""
		  if !plan_service.blank?
		  	if service_plans.blank?
		  		render :json=>{:status=>plan_service.as_json,:present=>"true",:service_item_create=>"false"}
		  	else
		  		render :json=>{:status=>plan_service.as_json,:present=>"true" ,:service_item_create=>"true"}
		  	end
		  else
		  	render :json=>{:status=>"Service Item Not Found.." ,:present=>"false"}
		  end
		else
			render :json=>{:status =>"Failure Please Login"}
		end	
	end

	def service_item_create
		if current_user
			service_plans = current_user.service_plans.where(:property_id=>params[:property_id]).last
			if service_plans
				if service_plans.update(service_items_params)
					render :json=>{:status=>service_plans.as_json}
				else
					render :json=>{:status=>"Something went wrong"}
				end
			else
				service_plan_id = Property.find(params[:property_id]).server_plan_id rescue ""
                if !service_plan_id.blank?
                	@service_plans=ServicePlan.new(select_service_items_params)
                	if @service_plans.save
                		render :status=>"service plan not selected",:json=>{:status =>@service_plans.as_json}
                	else
                		render :status=>"something went wrong"
                	end
                else
					@service_plans=ServicePlan.new(selected_service_items_params)
					 if @service_plans.save
						@property = Property.find(params[:property_id])
						@property.server_plan_id = @service_plans.id
						@property.save
						render :status=>"service plan not selected",:json=>{:status =>@service_plans.as_json}
					else
						render :json=>{:status=>"Something went wrong"}
					end
				end	
			end
		else
			render :json=>{:status =>"Failure Please Login"}
		end
	end

	def service_item_display
		if current_user
			service_plan_id = Property.find(params[:property_id]).server_plan_id rescue ""
        if service_plan_id.blank?
        	render :json=>{:status =>"Service plan not present"}
        else
        	plan_service = ServicePlan.where(:property_id=>params[:property_id]).first rescue ""
        	if plan_service.blank?
        		plan_service = ServicePlan.find(service_plan_id) rescue ""
        		render :json=>{:status =>plan_service.as_json}
        	else
        		render :json=>{:status=>plan_service.as_json}
        	end
        end
		else
			render :json=>{:status =>"Failure Please Login"}
		end
	end
  
	private
		def current_user
			User.find(params[:user_id]) rescue ""
		end

		def chemical_params
			params.require(:chemical).permit(:liquid_chlorine_gal,:di_chlor_ib,:tri_chlor_ib,:muriatic_acid_gal,:dry_muriatic_acid_lb,:bromine_tans,:soda_ash_lb,:sodium_bicarbonate_lb,:salt_bags,:water_clarifier_oz,:algacide_oz,:phosphate_remover,:user_id,:liquid_chlorine_select,:di_chlor_select,:tri_chlor_select,:muriatic_acid_select,:dry_muriatic_acid_select,:bromine_tans_select,:soda_ash_select,:sodium_bicarbonate_select,:salt_bags_select,:water_clarifier_select,:algacide_oz_select,:phosphate_remover_select,:property_id,:source,:date,:id,:created_at,:updated_at)
		end

		def test_pool_params
			params.require(:pool_test).permit(:chlorine,:ph_value,:salt_level,:total_alkalinity,:calcium_hardness,:user_id,:property_id,:source,:date)
		end

		def service_items_params
			params.require(:service_item).permit(:user_id,:waterline_tiles_cleaned,:property_id,:notes_to_customer,:inspected_pump,:checked_water_level,:vacuumed_pool,:cleaned_pump_basket,:cleaned_skimmer_baskets,:brushed_walls_steps,:netted_surface_debris,:filter_cleaned,:statusbackwash,:pump_strainer_baskets, :filter_pressure_monitor, :customer_note, :status, :name, :description, :unit_cost, :skimming_surface, :floor_vacuumed, :pool_sweep_cleaner, :net_surface_bottom, :inspect_pool_spa_eqip, :wipe_ladder_handrails, :add_water_needed, :adjust_timeclock, :backwash)
		end

		def selected_service_items_params
			params.require(:service_item).permit(:user_id,:customer_note, :status,:name,:description)
		end

		def select_service_items_params
			params.require(:service_item).permit(:user_id,:customer_note, :status,:property_id)
		end
end