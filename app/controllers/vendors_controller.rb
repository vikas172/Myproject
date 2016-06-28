class VendorsController < ApplicationController
 before_action :authenticate_user!
 include VendorsHelper

# Custom Vendor display
  def index
    @vendors = current_user.vendors
  end

# Custom Vendor new
  def new
    @vendor = Vendor.new
  end

# Custom Vendor create
  def create
    @vendor = current_user.vendors.create(vendor_params)
    redirect_to @vendor
  end

# Custom Vendor edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

# Custom Vendor Update
  def update
    @vendor = Vendor.find(params[:id])
    @vendor.update(vendor_params)
    redirect_to vendors_vendor_setting_path
  end

# Custom Vendor destroy
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    redirect_to vendors_path
  end

# Custom Vendor show view
  def show
    @vendor = Vendor.find(params[:id])
  end

# Import vendor file within database
  def import_vendor
    Vendor.import(params[:file])
    redirect_to root_url, notice: "Vendor imported."
  end

# View Vendor setting contain map 
  def vendor_setting
    require 'open_weather' 
    @address = []
    @pref_vendors = []
    @vendor = current_user.vendor_setting
    @vendors = Vendor.all.where(:user_id => [current_user.id,nil])
    if !@vendor.blank?
      if @vendor.prefer_marker == "preference"
         @address = get_preference_vendors(@vendor,@pref_vendors)
      else
        @add = get_alladdress_miles(@vendors,@vendor)
        @add.collect{|p| @address << { name:"#{p.street} , #{p.city} ,#{p.zipcode}, <a href=/vendors/add_preference?vendors=#{p.id}&map=marker data-remote=true>Add Preference</a>", latitude: p.latitude, longitude: p.longitude}}
      end
    end
    vendors_locations
    get_vendors_radius(@vendor)
  end

#get vendors location through lat and long
  def vendors_locations
    options = { units: "metric", APPID: WEATHER_APPID }
    res = OpenWeather::Current.city("#{current_user.street} ,#{current_user.city}", options) rescue ""
    @lat = res["coord"]["lat"] rescue "40.73"
    @lng = res["coord"]["lon"] rescue "-73.93"
  end

#get vendors locations and display marker accordingly
  def get_vendors_radius(vendor)
    if vendor.blank?
      @radius = 25
      @icons = "green-dot.png"
    elsif vendor.vendor_miles.blank?
      @radius =25
      @icons = "green-dot.png" if vendor.prefer_marker == "miles"
      @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
    else
      @icons = "green-dot.png" if vendor.prefer_marker == "miles"
      @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
      @radius =vendor.vendor_miles
    end
  end

#collect preference vendors
  def get_preference_vendors(vendor_setting,pref_vendors)
   if !vendor_setting.preference_vendor.blank?
        vendor_setting.preference_vendor.each do |id|
          p = Vendor.find(id)
          pref_vendors << { name:"#{p.street} , #{p.city} ,#{p.zipcode} , <a href=/vendors/add_preference?vendors=#{p.id}&map=marker data-remote=true>Add Preference</a>", latitude: p.latitude, longitude: p.longitude}
        end
        return pref_vendors
      end
  end


# Create and Update VendorSetting
  def vendor_customize
    if current_user.vendor_setting.blank?
      @vendor =VendorSetting.new(:vendor_type=>params[:vendors],:vendor_miles=>params[:miles],:preference_vendor=>params[:vendor_list],:prefer_marker=>params[:prefer_marker],:user_id=>current_user.id)
      @vendor.save
    else
      @vendor = current_user.vendor_setting
      @vendor.update(:vendor_type=>params[:vendors],:vendor_miles=>params[:miles],:prefer_marker=>params[:prefer_marker])    
    end
    redirect_to :back
  end

# Import vendor file in our browse section 
  def import_file
  end

# Search  vendors through city and zipcode
  def search_vendors
    if !params[:zipcode].blank?
      @vendors=Vendor.all.where(:user_id => [current_user.id,nil]).where('lower(city) = ? OR zipcode LIKE ?', "#{params[:city].downcase}","#{params[:zipcode]}%")
      @detail = ZipCodes.identify(params[:zipcode]) if @vendors.blank?
      @vendor =Vendor.near(@detail[:city]) if !@detail.blank?
      @vendors = [] if @vendors.blank?
      @vendor.collect{|p| @vendors << p if @detail[:state_code] == p.state} if !@vendor.blank?
    else
      @vendors=Vendor.all.where(:user_id => [current_user.id,nil]).where('lower(city) = ? OR zipcode LIKE ?', "#{params[:city].downcase}","#{params[:zipcode]}")
      @vendors =Vendor.near(params[:city])  if @vendors.blank?
    end  
  end

# Display preference vendors on modal popup
  def preference_vendors
    @vendors =[]
    @vendor= current_user.vendor_setting
    if !@vendor.blank?
      if !@vendor.preference_vendor.blank?
        @vendor.preference_vendor.each do |id|
          @vendors << Vendor.find(id) 
        end
      end
    end
  end

# Add Preference on vendor setting
  def add_preference
    params[:vendors] = params[:vendors].split() if params[:map] == "marker"
    if !current_user.vendor_setting.blank?
      pref_vendor_present(params)
    else
      vendor_new_pref(params)
    end
    current_user.vendor_setting.preference_vendor = current_user.vendor_setting.preference_vendor.uniq
    current_user.vendor_setting.save
    render nothing: true
  end

# Call add_preference method for vendor setting are present
  def pref_vendor_present(params)
    if !current_user.vendor_setting.preference_vendor.blank?
      params[:vendors].each do |vendor|
        if (vendor.to_i != 0)
          current_user.vendor_setting.preference_vendor << vendor
        end
      end
      current_user.vendor_setting.save
    else
      pref_vendor_blank(params,current_user.vendor_setting)
    end
  end

# Call add_preference method for vendor setting whose preference vendor nil
  def pref_vendor_blank(params,vendor_setting)
    vendor_setting.preference_vendor =[]
    params[:vendors].each do |vendor|
      if (vendor.to_i != 0)
        vendor_setting.preference_vendor << vendor
      end
    end
    vendor_setting.save
  end 

# Call add_preference method for create new vendor setting
  def vendor_new_pref(params)
    vendor_setting = VendorSetting.new
    vendor_setting.preference_vendor=[]
    params[:vendors].each do |vendor|
      if (vendor.to_i != 0)
        vendor_setting.preference_vendor << vendor
      end
    end
    vendor_setting.user_id = current_user.id
    vendor_setting.save
  end

  private
    def vendor_params
      params.require(:vendor).permit(:vendor_type, :name, :location_name, :street, :city, :state, :zipcode, :phone, :fax, :source)
    end
end
