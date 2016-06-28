class ServiceRemindersController < ApplicationController
  before_action :set_service_reminder, only: [:show, :edit, :update, :destroy]

  # GET /service_reminders
  # GET /service_reminders.json
  def index
    service_reminders = ServiceReminder.all
    @service_reminders = current_user.service_reminders
  end

  # GET /service_reminders/1
  # GET /service_reminders/1.json
  def show
  end

  # GET /service_reminders/new
  def new
    @service_reminder = ServiceReminder.new
    team_member
  end
#get all user i.e. admin and its team member
  def team_member 
    if current_user.user_type=="admin"
      @team=current_user.team_members.where('member_id IS NOT NULL')
      @user_list=@team
      @clients_list=current_user.clients
    else
      @team=[]
      @user1=[]
      @user = @team_member.user
      @user_team= @team_member.user.team_members.where("member_id!=?",current_user.id)
      @team <<  @user
      if !@user_team.blank?
        @user_team.each do |team|
          @user1 << User.find(team.member_id)
        end
        @team << @user1
      end  
      @team = @team.flatten
      @user_list=@team
    end
  end 

  # GET /service_reminders/1/edit
  def edit
    team_member
    @service_reminder = ServiceReminder.find(params[:id])
    @team_member = @service_reminder.subscribed_user
    @user_name = User.find(@team_member).collect(&:full_name) rescue ""
  end

  # POST /service_reminders
  # POST /service_reminders.json
  def create
    @service_reminder = ServiceReminder.new(service_reminder_params)
     @service_reminder.user_id = current_user.id
    if params[:service_reminder][:subscribed_user].blank?
      @service_reminder.subscribed_user = (current_user.id).to_s.split()
    else
      @service_reminder.subscribed_user = params[:service_reminder][:subscribed_user]
    end
    respond_to do |format|
      if @service_reminder.save
        #format.html { redirect_to @service_reminder, notice: 'Service reminder was successfully created.' }
        #format.json { render :show, status: :created, location: @service_reminder }
        format.html { redirect_to vehicles_path(static_data:"static_reminder"), notice: 'Service reminder was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @service_reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_reminders/1
  # PATCH/PUT /service_reminders/1.json
  def update
    respond_to do |format|
      if @service_reminder.update(service_reminder_params)
        #format.html { redirect_to @service_reminder, notice: 'Service reminder was successfully updated.' }
        #format.json { render :show, status: :ok, location: @service_reminder }
        format.html { redirect_to vehicles_path(static_data:"static_reminder"), notice: 'Service reminder was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @service_reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_reminders/1
  # DELETE /service_reminders/1.json
  def destroy
    @service_reminder.destroy
    respond_to do |format|
      #format.html { redirect_to service_reminders_url, notice: 'Service reminder was successfully destroyed.' }
      #format.json { head :no_content }
      format.html { redirect_to vehicles_path(static_data:"static_reminder"), notice: 'Service reminder was successfully destroyed.' }
    end
  end

#send service notification mail
  def service_notification
    @service_reminder = ServiceReminder.all
    @service_reminder.each do |service_reminder|
      if service_reminder.email_notification == true
        subscribed_user = service_reminder.subscribed_user
        subscribed_users = User.find(subscribed_user)
        #subscribed_user = User.where(:id=>params[:service_reminder][:subscribed_user])
        subscribed_users.each do |subscrib_user|
          @email = subscrib_user.email
          if service_reminder.time_duration == "day(s)"
            if (Date.today == (service_reminder.created_at.to_date + (service_reminder.time_interval.to_i).days))
               UserMailer.service_reminder_notification(service_reminder,@email).deliver
            end
          elsif service_reminder.time_duration == "week(s)"
            if (Date.today == (service_reminder.created_at.to_date + (service_reminder.time_interval.to_i).weeks))
               UserMailer.service_reminder_notification(service_reminder,@email).deliver
            end
          else
            if (Date.today == (service_reminder.created_at.to_date + (service_reminder.time_interval.to_i).months))
               UserMailer.service_reminder_notification(service_reminder,@email).deliver
            end
          end
        end
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_reminder
      @service_reminder = ServiceReminder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_reminder_params
      params.require(:service_reminder).permit(:user_id, :vehicle_name, :service_task, :meter_interval, :time_interval, :time_duration, :meter_threshold, :time_threshold, :threshold_duration, :email_notification, :subscribed_user)
    end
end
