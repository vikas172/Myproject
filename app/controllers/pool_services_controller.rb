class PoolServicesController < ApplicationController

#Create new pool service object
	def pool_service
		@pool_service = current_user.pool_service 
		@pool_service = PoolService.new if @pool_service.blank?
	end

#create spa service object
	def spa_service
		@pool_service = current_user.spa_service
		@pool_service = SpaService.new if @pool_service.blank?
	end

#store spa and pool service object
	def service_create
		if params[:service_type]  == "spa_service"
			@pool_service= SpaService.new(spa_params)
		else
			@pool_service= PoolService.new(pool_params)
		end
		@pool_service.save
		redirect_to :back
	end

#Update  spa service, pool service, pool test and service_items
	def update
		if params[:service_type]  == "spa_service"
			current_user.spa_service.update(spa_params) rescue ""
		elsif params[:service_type]  == "pool_service"
			current_user.pool_service.update(pool_params) rescue ""
		elsif params[:service_type]  == "pool_test"
      current_user.pool_tests.where(:property_id=>params[:pool_test][:property_id]).last.update(test_pool_params) rescue ""
		elsif params[:service_type] == "service_items" 
			current_user.service_plans.where(:property_id=>params[:service_plan][:property_id]).last.update(service_plan_params) rescue ""
			@service_plan= current_user.service_plans.where(:property_id=>params[:service_plan][:property_id]).last
			if params[:send]=="email"
				UserMailer.service_item(params,@service_plan,current_user).deliver
			end
		else
			current_user.chemical_items.where(:property_id=>nil).last.update(chemical_params) rescue ""
		end
		redirect_to :back	
	end

#Create chemical item new object
	def chemical_items
		@chemical_items= current_user.chemical_items.where(:property_id=>nil).last
		@chemical_items= ChemicalItem.new if @chemical_items.blank?
	end

#Create chemical item
	def chemical_items_create
		@chemical_items = ChemicalItem.new(chemical_params)
		@chemical_items.save
		redirect_to :back
	end

#Pool Test result if its range present then display the result otherwise vaule display	
	def pool_chemical_test
		@pool_service = current_user.pool_service 
		@pool_test = current_user.pool_tests.where(:property_id=>params[:property_id]).last
		@pool_test= PoolTest.new if @pool_test.blank?
	end

#create test pool object and store in database
	def check_pool_test
		@pool_test= PoolTest.new(test_pool_params)
		@pool_test.save
		redirect_to :back
	end

#Chemical used to add chemical on the pool after see the test result
	def chemical_used
		@check_used =current_user.chemical_items.where(:property_id=>nil).last
		@chemical_used = current_user.chemical_items.where(:property_id=>params[:property_id]).last
		@chemical_used = ChemicalItem.new if @chemical_used.blank?
	end

#After see the test result add chemical to the pool then its in stable condition
	def chemical_used_create
		@chemical_used = ChemicalItem.new(chemical_params)
		@chemical_used.save
		redirect_to :back
	end

# After select the paln builder on the pool show, service item tab appear on the pool show
	def service_items
		@plan_label = current_user.service_plan_label
		@plan_label = ServicePlanLabel.new if @plan_label.blank?
		service_plan_id = Property.find(params[:property_id]).server_plan_id rescue ""
		@plan_service = ServicePlan.find(service_plan_id) rescue ""
		@service_plans=current_user.service_plans.where(:property_id=>params[:property_id]).last
		@service_plans= ServicePlan.new if @service_plans.blank?
	end

#Model popup open display list of service item and fill the detail and store it
	def service_items_create
		@service_plans=ServicePlan.new(service_plan_params)
		@service_plans.save
		redirect_to :back
	end
#Under setting i.e. work setting market source option their
	def market_source
		@market_sources = MarketSource.where(:user_id=>current_user.id)
	end
 
 #Create the market source object
 	def source_create
 		@source = MarketSource.new(market_sources_params)
 		@source.save
 		@market_sources = MarketSource.where(:user_id=>current_user.id)
	end

#Market source object edit
	def source_edit
		@source= MarketSource.find(params[:id])
	end

#Update market source
	def source_update
		@source= MarketSource.find(params[:id])
		@source.update(market_sources_params)
		redirect_to market_source_pool_services_path
	end

#destory market source object
	def source_delete
		@source= MarketSource.find(params[:id])
		@source.destroy
		redirect_to :back
	end

#Its appear on the setting pannel ,service Create plan builder to display on pool show view 
	def service_plan
		@service_plan = ServicePlan.new
		@plan_label = current_user.service_plan_label
		@plan_label = ServicePlanLabel.new if @plan_label.blank?
		@service_plans = current_user.service_plans.where(:property_id=>nil)
	end

#AFter fill the plan builder information submit 
	def service_plan_create
		@service_plan = ServicePlan.new(service_plan_params)
		@service_plan.save
		@service_plans = current_user.service_plans
		redirect_to :back
	end

# plan builder destory
	def service_plan_delete
		@service_plan = ServicePlan.find(params[:id])
		@service_plan.destroy
		redirect_to service_plan_pool_services_path
	end

#plan builder on the setting tab
	def service_plan_edit
		@service_plan = ServicePlan.find(params[:id])
		@plan_label = current_user.service_plan_label
		@plan_label = ServicePlanLabel.new if @plan_label.blank?
	end

#plan builder attributes label changes
  def service_plan_label
  	@plan_label = current_user.service_plan_label
  	@plan_label= ServicePlanLabel.new if @plan_label.blank?
  end

#Update plan builder label changes
  def update_plan_label
  	plan_label = current_user.service_plan_label
  	if plan_label.blank?
	  	plan_label = ServicePlanLabel.new(plan_label_params)
	  	plan_label.user_id = current_user.id
	  	plan_label.save
	  else
	  	plan_label.update(plan_label_params)
	  end	
  	redirect_to :back
  end

#Update plan builder 
	def service_plan_update
		@service_plan = ServicePlan.find(params[:id])
		@service_plan.update(service_plan_params)
		redirect_to service_plan_pool_services_path
	end

	private
		def pool_params
			params.require(:pool_service).permit(:ph_low, :ph_high, :ph_select, :ch_low, :ch_high, :ch_select, :combined_ch_low, :combined_ch_high,:combined_select,:alkalinity_low,:alkalinity_high,:alkalinity_select,:calcium_hardness_low,:calcium_hardness_high,:calcium_select,:stabilizer_low,:stabilizer_high,:stabilizer_select,:salt_low,:salt_high,:salt_select,:dissolved_soild_low,:dissolved_soild_high,:dissolved_select,:saturation_index_low,:saturation_index_high,:saturation_select,:user_id)
		end
		
		def spa_params
			params.require(:spa_service).permit(:ph_low, :ph_high, :ph_select, :ch_low, :ch_high, :ch_select, :combined_ch_low, :combined_ch_high,:combined_select,:alkalinity_low,:alkalinity_high,:alkalinity_select,:calcium_hardness_low,:calcium_hardness_high,:calcium_select,:stabilizer_low,:stabilizer_high,:stabilizer_select,:salt_low,:salt_high,:salt_select,:dissolved_soild_low,:dissolved_soild_high,:dissolved_select,:saturation_index_low,:saturation_index_high,:saturation_select,:user_id)
		end
		
		def chemical_params
			params.require(:chemical_item).permit(:liquid_chlorine_gal,:di_chlor_ib,:tri_chlor_ib,:muriatic_acid_gal,:dry_muriatic_acid_lb,:bromine_tans,:soda_ash_lb,:sodium_bicarbonate_lb,:salt_bags,:water_clarifier_oz,:algacide_oz,:phosphate_remover,:user_id,:liquid_chlorine_select,:di_chlor_select,:tri_chlor_select,:muriatic_acid_select,:dry_muriatic_acid_select,:bromine_tans_select,:soda_ash_select,:sodium_bicarbonate_select,:salt_bags_select,:water_clarifier_select,:algacide_oz_select,:phosphate_remover_select,:property_id,:source,:date)
		end

		def test_pool_params
			params.require(:pool_test).permit(:chlorine,:ph_value,:salt_level,:total_alkalinity,:calcium_hardness,:user_id,:property_id,:source,:date)
		end

		def service_items_params
			params.require(:service_item).permit(:user_id,:property_id,:notes_to_customer,:inspected_pump,:checked_water_level,:vacuumed_pool,:cleaned_pump_basket,:cleaned_skimmer_baskets,:brushed_walls_steps,:netted_surface_debris,:filter_cleaned,:status)
		end

		def market_sources_params
			params.require(:market_source).permit(:user_id,:source_name)
		end

		def service_plan_params
			params.require(:service_plan).permit(:name,:description,:unit_cost,:user_id,:property_id,:notes_to_customer,:adjust_timeclock,:notes_to_customer,:filter_pressure_monitor,:add_water_needed,:wipe_ladder_handrails,:inspect_pool_spa_eqip,:net_surface_bottom,:pool_sweep_cleaner,:inspected_pump,:checked_water_level,:vacuumed_pool,:cleaned_pump_basket,:pump_strainer_baskets,:floor_vacuumed,:netted_surface_debris,:cleaned_skimmer_baskets,:waterline_tiles_cleaned,:skimming_surface,:brushed_walls_steps,:backwash,:filter_cleaned,:customer_note,:status)
		end

		def plan_label_params
			params.require(:service_plan_label).permit(:notes_to_customer,:adjust_timeclock,:notes_to_customer,:filter_pressure_monitor,:add_water_needed,:wipe_ladder_handrails,:inspect_pool_spa_eqip,:net_surface_bottom,:pool_sweep_cleaner,:inspected_pump,:checked_water_level,:vacuumed_pool,:cleaned_pump_basket,:pump_strainer_baskets,:floor_vacuumed,:netted_surface_debris,:cleaned_skimmer_baskets,:waterline_tiles_cleaned,:skimming_surface,:brushed_walls_steps,:backwash,:filter_cleaned)
		end

end
