module IvrsHelper

  def actual_key(key, parent_key)
    parent_key ? parent_key : key
  end

  def key_action_wrapper_id(key, parent_key)
    if parent_key
      "#{parent_key.digit}_#{key.digit}"
    else
      "#{key.digit}"
    end
  end

  def filter_options_if_sub_menu(ivr)
    if ivr.is_sub_menu
      ActionType.where.not(:code => "TSB").order(:display_order)
    else
      ActionType.where.not(:code => "GTPM").order(:display_order)
    end
  end

  def ivr_state(ivr)
    if ivr.state.blank? or ivr.state == "active"
      #demo ivr
      return "Active"
    elsif ivr.state == "pending_activation"
      #return  link_to "Activate" , home_pricing_url , :target => :blank
      return "Pending Activation"
    end
  end

  #on settings page
  def display_ivr_number(ivr)
    if @ivr.phone and @ivr.phone.first != "+"
      "+" + $country_codes[@ivr.region] +" "+ number_to_phone(@ivr.phone, :area_code => true)
    elsif @ivr.phone
      number_to_phone(@ivr.phone, :area_code => true)
    else
      "None"
    end

  end

end
