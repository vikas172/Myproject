class RegistrationsController < Devise::RegistrationsController
layout false ,except:[:edit]

  def create
   if params[:inviter_id].blank?
    super
    if current_user
      current_user.full_name = current_user.first_name
      current_user.save
      create_sample_client(current_user) 
    end
   else
    @user=User.create(:username=>params[:user][:user_name],:first_name=>params[:user][:user_name],:full_name=>params[:user][:full_name],:email=>params[:user][:email],:password=>params[:user][:password],:password_confirmation=>params[:user][:password_confirmation],:user_type=>"user",:company_name=>params[:user][:company_name],:marker_color=>params[:user][:marker_color])
    update_team_member(@user.id,params)
    sign_in @user ,:bypass=>true
    redirect_to after_sign_in_path_for(@user)
   end
  end

  def update
     account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # required for settings form to submit when password is left blank
    account_update_params[:password]=params[:password]
    account_update_params[:password_confirmation]=params[:password_confirmation]
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    account_update_params.delete("current_password")
    if @user.update_attributes(account_update_params)
      require 'RMagick'
      
      current_user.avatar = params[:user][:avatar]
      current_user.avatar.save
      attachment=current_user.avatar
      if (!params[:jcrop_holder_width].blank? && !params[:jcrop_holder_height].blank? )
        image_src =  Magick::Image.from_blob(params[:user][:avatar].read)
        image_resize_coordinates = image_src.first.resize_to_fill(params[:jcrop_holder_width].to_i, params[:jcrop_holder_height].to_i)
        cropped_image = image_resize_coordinates.crop(params[:user_edit][:crop_x].to_i,params[:user_edit][:crop_y].to_i,params[:user_edit][:crop_w].to_i,params[:user_edit][:crop_h].to_i)
        list = Magick::ImageList.new
        list << cropped_image
         
        image_name = "profile"+""+Time.now.strftime('%Y%H%M%S').to_s+".jpg"
        attach =list.write(url = "#{Rails.root}/tmp/"+image_name)
        current_user.avatar = File.open(url)
        current_user.save
      end  
      if !params[:initial_phone].blank? && !params[:user][:mobile_number].blank?
        @user.mobile_number=params[:initial_phone] + params[:user][:mobile_number]
        @user.save
      end
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private
  def update_team_member(user_id,params)
    @team_member=TeamMember.find(params[:inviter_id])
    @team_member.member_id= user_id
    @team_member.save
    @permission=@team_member.permission
    @permission.user_id= user_id
    @permission.save
  end

  def create_sample_client(current_user)
    # @client=Client.create(:initial=>"",:first_name=>"CopperService",:last_name=>"client",:company_name=>"CopperService",:user_id=>current_user.id)
    # @client.properties.create(:street=>"200, 10218-82 Avenue",:street2=>"",:city=>"Edmonton",:state=>"Alberta",:zipcode=>"T6E 1Z8",:country=>"CA")
    # @client.phones.create(:primary_phone=>["false"],:phone_initial=>["Main"],:phone_number=>["888-721-1115"])
    # @client.emails.create(:primary_email=>["false"],:email_initial=>["Main"],:email=>["support@getcopperservice.com"])
    # @client1=Client.create(:initial=>"",:first_name=>"Sample",:last_name=>"Client",:company_name=>"Company",:user_id=>current_user.id)
    # @client1.properties.create(:street=>"",:street2=>"",:city=>"New York",:state=>"Pennsylvania",:zipcode=>"17406",:country=>"US")
    # @client1.phones.create(:primary_phone=>["false"],:phone_initial=>["Main"],:phone_number=>["123-456-7890"])
    # @client1.emails.create(:primary_email=>["false"],:email_initial=>["Main"],:email=>["sample@example.com"]) 
end
end
