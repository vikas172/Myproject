class TwiliosController < ApplicationController

#buy a number for twilio use to send sms
  def buy_a_number
  	@general_info=current_user.general_info
    if !params[:area_code].blank?
      client = Twilio::REST::Client.new $account_sid,$auth_token 
      begin
        @number = client.account.incoming_phone_numbers.create(
                    :area_code => params[:area_code])
        '<b>Success!</b> You now own the number <b>' + @number.phone_number + '</b>.'
      rescue StandardError => e
        '<b>Sorry!</b> ' + e.message + '.'
        @message=e.message
      end
    end  
    if !@number.blank?  
      @general=current_user.general_info
      if !@general.blank?
	      @general.service_number= @number.phone_number rescue ""
	      @general.area_code=params[:area_code] if !params[:area_code].blank?
	      @general.save
	    else
	    	@general=GeneralInfo.new
	    	@general.service_number= @number.phone_number rescue ""
	      @general.area_code=params[:area_code] if !params[:area_code].blank?
	      @general.user_id=current_user.id
	      @general.save
	    end  
    end
    @general_info=GeneralInfo.find_by_user_id(current_user.id)
  end

# send today sms and message 
  def today_message_send
    @job=Job.where(:user_id=>current_user.id).collect(&:id)
    @today_schedule=VisitSchedule.where(:job_id=> @job,:start_date=>Date.today,:job_complete=>false)
    @today_event=current_user.events.where(:start_date=>Date.today)
    @today_basic=current_user.basic_tasks.where("start_at_date <? AND end_at_date >=? AND is_completed=?",Date.today,Date.today,false)
    if params[:message]=="email"
      email_client_user(@today_schedule,params)
      redirect_to request.referrer , notice: 'Email send sucessfully' 
    elsif params[:message]=="sms"
      @general_info = current_user.general_info
      if !@general_info.blank?
        @from= @general_info.service_number
        if !@from.blank?
          sms_client_user(@today_schedule,params,@from)
          redirect_to request.referrer , notice: 'Message send sucessfully'
        else
          session[:today_message_send]= 'Message not send please Set up service number'
          redirect_to request.referrer 
        end
      else
        session[:today_message_send]= 'Message not send please Set up service number'
        redirect_to request.referrer 
      end     
    end 
  end

# Send today notice mail to client and user
  def email_client_user(schedule,params)
    if !schedule.blank?
      schedule.each do |sch|
        @client = sch.job.property.client
        @user = sch.job.property.client.user
        if (( !params[:email_client].blank?) && ( !params[:email_user].blank?))
          UserMailer.today_notice_mail_client(@client,sch).deliver
          UserMailer.today_notice_mail_user(@user,sch).deliver
        elsif !params[:email_client].blank?
          UserMailer.today_notice_mail_client(@client,sch).deliver
        elsif !params[:email_user].blank?
          UserMailer.today_notice_mail_user(@user,sch).deliver
        end
      end
    end
  end

# send sms to client and user 
  def sms_client_user(schedule,params,from)
    @from=from
    if !schedule.blank?
      schedule.each do |sch|
        @twilio_client = Twilio::REST::Client.new  $account_sid,$auth_token 
        @client= sch.job.property.client
        @user= sch.job.property.client.user
        sms_content= "Today job visit"
        if (( !params[:message_client].blank?) && ( !params[:message_user].blank?))
          if !@user.mobile_number.blank?
            @twilio_client.account.sms.messages.create({:from => @from, :to =>@user.mobile_number , :body =>sms_content})  
          end
          @twilio_client.account.sms.messages.create({:from => @from, :to =>@client.mobile_number , :body =>sms_content})  
        elsif !params[:message_client].blank?
          @twilio_client.account.sms.messages.create({:from => @from, :to =>@client.mobile_number , :body =>sms_content})  
        elsif !params[:message_user].blank?
          if !@user.mobile_number.blank?
            @twilio_client.account.sms.messages.create({:from => @from, :to =>@user.mobile_number , :body =>sms_content})  
          end
        end
      end
    end
  end

#Display the list of user to display on dropdown
  def new_message
    if current_user.user_type=="admin"
      @team=current_user.team_members.where('member_id IS NOT NULL')
      @clients=current_user.clients
    else
      @team=[]
      @user1=[]
      @user = @team_member.user
      @user_team= @team_member.user.team_members.where("member_id!=?",current_user.id)
      @team <<  @user
      @clients=@user.clients
      if !@user_team.blank?
        @user_team.each do |team|
          @user1 << User.find(team.member_id)
        end
        @team << @user1
      end  
      @team = @team.flatten
    end
  end

# sms create or send  
  def message_create
    @twilio_client = Twilio::REST::Client.new  $account_sid,$auth_token 
    @user_number=params[:number]
    if !current_user.general_info.blank?
      if !current_user.general_info.service_number.blank?
        @from = current_user.general_info.service_number
        
        @twilio_client.account.sms.messages.create({:from => @from, :to =>@user_number , :body =>params[:body]}) rescue ""
        
        redirect_to dashboard_path , notice: 'Sms send Sucessfully.'
      else
        redirect_to buy_a_number_path , notice: 'Please Buy a Service Number first'
      end
    else
        redirect_to buy_a_number_path , notice: 'Please Buy a Service Number first'
    end  
  end

#Show list of sms on twilio account
  def message_show
    @twilio_client = Twilio::REST::Client.new  $account_sid,$auth_token 
    @sms = @twilio_client.account.sms.messages.get(params[:id])  
  end

#delete twilio service number
  def delete_service_number
    @general_info=current_user.general_info
    if !@general_info.blank?
      if !@general_info.service_number.blank?
        client = Twilio::REST::Client.new  $account_sid,$auth_token 
        client.account.incoming_phone_numbers.list.each do |num|
          if @general_info.service_number ==  num.phone_number
            num.delete
            @general_info.service_number=""
            @general_info.area_code=""
            @general_info.save
          end   
        end
      end
    end 
    redirect_to request.referrer
  end
end
