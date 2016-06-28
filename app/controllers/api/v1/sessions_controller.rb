class Api::V1::SessionsController < Api::V1::ApiController 
    # before_filter :authenticate_user!, :except => [:create]
    skip_before_filter  :verify_authenticity_token 
    respond_to :json
    
    def create  

        email = params[:email]
        password = params[:password]

        if email.nil? and password.nil?
          render :status=>400,
          :json=>{:status=>"The request must contain the user email and password."}
          return
        end

        @user=User.find_by_email(email.downcase)
     
        if @user.blank?
          logger.info("User #{email} failed signin, user cannot be found.")
          render :json=>{:status=>"Invalid email or passoword."}
          return
        end
        if not @user.valid_password?(password)
          logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
          render :json=>{:status=>"Invalid email or password."}
        else
          sign_in("user", @user)
          render :json=>{:status => "Success",:user_id=>@user.id,:first_name=>@user.first_name,:last_name=>@user.last_name
            }
        end
    end

    def destroy
        if !current_user
          render  :json=>{:status=>"Please login first"}
          return
        end 

       if  Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)      
          render  :json=>{:status=>"Success"}
          return
        else
            render :json=>{:status=>"0"}
            return
        end
    end
end
