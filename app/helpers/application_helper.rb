module ApplicationHelper
 def major_currencies(hash)
      hash.inject([]) do |array, (id, attributes)|
      priority = attributes[:priority]
      if priority && priority < 10
        array ||= []
        array << [attributes[:name],attributes[:iso_code]]
      end
      array
    end
  end

  def all_currencies(hash)
    hash.inject([]) do |array, (id, attributes)|
      array ||= []
      array << [attributes[:name],attributes[:iso_code]]
      array
    end
  end

	def set_view_permission_client_property(team_member)
		if current_user.user_type=="user"
			if current_user.permission.permission_client_properties.count==2
				return true
			else
				return false
			end
		else
			return true	
		end	
	end

	def set_view_permission_work(team_member)
		if current_user.user_type=="user"
			if (current_user.permission.permission_quotes.count == 1) && (current_user.permission.permission_invoices.count == 1) && (current_user.permission.permission_jobs.count == 1)
				return false
			else
				return true
			end	
		else
			return true
		end
	end

# permissions give in buttons on client and property tab 
	def set_view_permission_client_property_view(team_member)
		if current_user.user_type=="user"
			if team_member.permission.permission_client_properties.count==2
				if team_member.permission.permission_client_properties.first=="1"
					return false
				else
      		return true
				end	
			else
				return false
			end
		else
			return true	
		end	
	end

	#permsission give under client and property tab contain jobs,invoices&quotes
  def set_view_permission_client_property_view_work(team_member)
  	if current_user.user_type=="user"
  		if team_member.permission.permission_quotes.count==2 || team_member.permission.permission_jobs.count==2 || team_member.permission.permission_invoices.count==2
  			return true
  		else
  		  return false	
  		end
  	else
  		return true
  	end
  end

  def set_view_permission_action_view_delete(permission_for)
  	if current_user.user_type=="user"
  		if permission_for.count==2
  			if permission_for.first=="3"
  				return true
  			else
  		  	return false	
  			end
  		else
  			return false
  		end	
  	else
  		return true
  	end
  end

  def set_view_permission_for_work_client_property(permission_for)
    
  	if current_user.user_type=="user"
  		if permission_for.count==2
  			return true
  		else
  			return false
  		end
  	else
  		return true
  	end	
  end

  def set_view_permission_add_work(permission_for)
  	if current_user.user_type=="user"
  		if permission_for.permission_jobs.first != "1" && permission_for.permission_quotes.first != "1" && permission_for.permission.invoices.first != "1" 
  			return true
  		else
  			return false
  		end
  	else
  		return true
  	end	
  end

  # Set view permission for Read Write & Delete only
  def set_view_permission_readwritedelete(permission_for)
  	if current_user.user_type=="user"
  		if permission_for.first== "1"
  			return "read"
  		elsif permission_for.first=="2"
  			return "write"
  		else
  		return "delete"	
  		end
  	else
  		return true
  	end	
  end

  def permission_for_edit_work_quotes(team_member)
    if current_user.user_type=="user"
      if team_member.permission.permission_quotes.first=="1"
        return "read"
      elsif team_member.permission.permission_quotes.first=="2"
        return "read_write"
      else
      return "read_write_delete"  
      end
    else
      return "read_write_delete"       
    end
  end

  def permission_for_edit_work_jobs(team_member)
    if current_user.user_type=="user"
      if current_user.permission.permission_jobs.first=="1"
        return "read"
      elsif current_user.permission.permission_jobs.first=="2"
        return "read_write"
      else
        return "read_write_delete"  
      end
    else
      return "read_write_delete"  
    end
  end

  def permission_for_edit_work_invoices(team_member)
    if current_user.user_type=="user"
      if current_user.permission.permission_invoices.first=="1"
        return "read"
      elsif current_user.permission.permission_invoices.first=="2"
        return "read_write"
      else
        return "read_write_delete"  
      end
    else
      return "read_write_delete"  
    end
  end

  def set_permission_for_work_quote_new(permission_for)
    if permission_for.count==2
      if permission_for.first=="1"
        return "read"
      elsif permission_for.first=="2" 
        return "read_write" 
      elsif permission_for.first=="3"
        return "read_write_delete" 
      end
    else
      return "read"
    end   
  end

  def set_permission_for_quote_job_convert(team_member)
    if current_user.permission.permission_jobs.count==2
      if current_user.permission.permission_jobs.first=="1"
        return "read"
      elsif current_user.permission.permission_jobs.first=="2"
        return "read_write"
      elsif current_user.permission.permission_jobs.first=="3"
        return "read_write_delete"
      end
    else  
     return "read" 
    end
  end

  def set_client_property_check_box_permission(permission)
    if permission.permission_jobs.count==2 || permission.permission_quotes.count == 2 || permission.permission_invoices.count == 2 || permission.permission_note_attachment.count==2 || permission.permission_reports==true
      return true
    else
      return false
    end
  end  
  
  def set_permission_attachment_note(team_member)
    if current_user.permission.permission_note_attachment.second=="1"
      return "read"
    elsif current_user.permission.permission_note_attachment.second=="2"
      return "read_write"
    elsif current_user.permission.permission_note_attachment.second=="3"
      return "read_write_delete"
    end
  end

  def set_permission_for_attachment(team_member)
    if team_member.permission.permission_note_attachment.count==2
      return true
    else
      return false
    end
  end  

  def active_home_nav(action)
    return "activenav-item" if params[:action]==action
    return "nav-item"
  end
  def active_home_page(action)
    return "active nav-item" if params[:action]==action
    return "nav-item"
  end
  def active_class(link_path)
    current_page?(link_path) ? "active nav-item" : "nav-item"
  end


  def get_dashboard_active(controller, action)
    return "selected" if params[:controller] == controller && params[:action] == action 
  end

  def get_calendr_active(controller, action)
    return "selected" if params[:controller] == "events"
  end

  def get_client_active(controller, action)
    return "selected" if params[:controller] == "clients" 
  end
  def get_prop_active(controller, action)
    return "selected" if params[:controller] == "properties"
  end

  def get_work_active(controller, action)
    return "selected" if (params[:controller] == "jobs" || params[:controller] == "quotes" || params[:controller] == "invoices" || params[:controller] == "chamicals") && (params[:action] != "chemical_treatment_setting")
  end

  def get_time_active(controller,action)
    return "selected" if (params[:controller] == "timesheets"  && params[:action]=="index") 
  end

  def get_management_active(controller, action)
    return "selected" if (params[:action]!="dashboard") && params[:action]!="general_account" && params[:action]!="users" && params[:action]!="company_brand" && params[:action]!="work_items"  && params[:action]!="custom_field" && (params[:controller] == "home" && params[:action] != "qb_show" && params[:action]!="routes")
  end

  def get_qb_active(controller, action)
  end

  def get_expense_active(controller, action)
    return "selected" if  params[:controller] == "expenses"  && params[:action]=="index" 
  end

  def get_chemical_active(controller, action)
    return "selected" if params[:controller] == "chamicals"
  end

  def get_report_active(controller, action)
    return "selected" if request.url.include? "reports"
  end

  def get_subtab_active(controller, action)
    if params[:action]!="payment_invoice"
      return "selected" if params[:controller] == "maps" && params[:action] == "routes"
      return "selected" if params[:controller] == controller && params[:action] == action
    else
      return "selected" if action =="payment_invoice" && controller == "pay_invoices"
    end
  end

  def get_subnav
    return  ((params[:controller] == 'jobs') ||(params[:controller]== 'quotes')||(params[:controller]=='invoices') || (params[:controller]== 'chamicals')) && (params[:action] != "chemical_treatment_setting" && params[:action] != "general_account")
  end

  def get_client_subnav
    return ((params[:action]=="reports") || (params[:action]=="routes")||(params[:action]=="client_list")||(params[:action]=='quote_list')||(params[:action]=='visits_list')||(params[:action]=='job_list')||(params[:action]=='recurring_contracts')) ||(params[:action]=='products_and_services') ||(params[:action]=='client_balance')||(params[:any]=='bad_debt')||(params[:action]=='projected_income')||(params[:action]=='aged_receivables')||(params[:action]=='invoice_list')||(params[:action]=='transactions')
  end

  def country_phone_code
    GeneralInfo::COUNTRY
  end

  def get_ivrs_numbers(controller, action)  
    return "selected-head" if (params[:controller] == "numbers" && params[:action] == "index")
  end

  def get_ivrs_analytics(controller, action)
    return "selected-head" if (params[:controller] == "ivrs" && params[:action] == "analytics")
  end
   
  def get_ivrs_active(controller, action)
    return "selected-head" if (params[:controller] == "ivrs" && params[:action] == "edit")
  end

  def get_ivrs_calls(controller, action)
    return "selected-head" if (params[:controller] == "ivrs" && params[:action] == "calls")
  end

end
