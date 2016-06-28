class EventsController < ApplicationController
  include EventsHelper
  include BasicTasksHelper
  include JobsHelper

  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /events
  # GET /events.json
#display visit scheduled, jobs, events, basic tasks.
  def index

    if current_user.user_type == "admin"
      @jobs= Job.where("scheduled=? AND job_complete=? AND user_id=?",false,false,current_user.id).collect(&:id)
      @unschdule_visit=VisitSchedule.where("job_complete=? AND job_id IN (?)",false,@jobs)
      @unschdule_tasks=current_user.basic_tasks.where(:start_at_date=>nil,:end_at_date=>nil,:is_completed=>false)
      get_json_data
    else
      @unschdule_tasks=[]
      @basic_task_un=BasicTask.where(:start_at_date=>nil,:end_at_date=>nil,:is_completed=>false)
      @basic_task_un.each {|p| @unschdule_tasks << p if p.assigned_to.include? current_user.id.to_s }
      # @unschdule_tasks=current_user.basic_tasks.where(:start_at_date=>nil,:end_at_date=>nil,:is_completed=>false)
      @jobs= @team_member.user.jobs.where("scheduled=? AND job_complete=? AND user_id=?",false,false,@team_member.user.id).collect(&:id)
      @unschdule_visit=VisitSchedule.where("job_complete=? AND job_id IN (?)",false,@jobs)
      get_team_member_data
    end
    @users = []
    @users << {id: "#{current_user.id}", title: "#{current_user.full_name}" ,eventColor: "##{current_user.marker_color}"}
    current_user.team_members.where("member_id is not NULL").each do |team|
       user=User.find(team.member_id)
       @users  << {id: "#{user.id}" , title: "#{user.full_name}",eventColor: "##{user.marker_color}"}
    end
     @basic =  current_user.basic_tasks.where("start_at_date is not NULL").collect{|p| { id: p.id,resourceId:p.user_id, title: p.title, :start => (p.start_at_date if !p.start_at_date.blank?), :end => (p.end_at_date if !p.end_at_date.blank?)}}
  end

#New event modal popup open 
  def to_dos
    if params[:unschedule].blank?
      @start_at = params[:todo][:start_at].to_date
      @end_at = params[:todo][:end_at].to_date
    else
      @start_at = Date.today
      @end_at = Date.today
    end  
    @event = current_user.events.new
  end

  # GET /events/1
  # GET /events/1.json
#display data on the calender  
  def show
    if current_user.user_type == "admin"
      get_json_data
    else
      get_team_member_data
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @start_at = @event.start_date
    @end_at = @event.end_date
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.new(event_params)
    @event.event_type="event"
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end  

#Drag and drop event and basic task
  def move
    if params[:type] =="basic"
      basic_move(params)
    else
      @event= Event.find(params[:id]) if params[:type] =="event"
      @event= VisitSchedule.find(params[:id]) if params[:type] =="visit"
      if @event
        @event.start_date = params[:start_date].to_date
        @event.end_date = params[:start_date].to_date
        @event.save
      end
    end  
    render :nothing => true
  end

# basic task move upmethod call  
  def basic_move(params)
    @event= BasicTask.find(params[:id]) 
    if @event
      @event.start_at_date = params[:start_date]
      @event.end_at_date  = params[:start_date]
      @event.save
    end
  end
  

  #view detail for event
  def view_detail
    @event = Event.find(params[:event_id])
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Action for visit
  def visit_complete_event
    @visit_schedule=VisitSchedule.find(params[:visit_schedule_id])
    if params[:job_type]== "on"
      @job=@visit_schedule.job
      if ((@job.start_date==nil) && (@job.end_date==nil))
        @job.update(:start_date=>params[:completed_on],:end_date=>params[:completed_on],:job_complete=>true,:complete_on=>params[:completed_on],:scheduled=>true)
        @visit_schedule.update(:start_date=>params[:completed_on],:end_date=>params[:completed_on],:completed_by=>params[:complete_by])
      end
      @visit_schedule.job_complete=true
      @visit_schedule.completed_by = params[:complete_by]
    else  
      @visit_schedule.job_complete = false
      @visit_schedule.completed_by = params[:complete_by]
      @visit_schedule.complete_on = Date.today.strftime("%Y/%m/%d")
    end
    @visit_schedule.save
    redirect_to events_url
  end

#visit view detail of events
  def visit_view_detail_event
    @visit = VisitSchedule.find(params[:visit_id])
    @visit_complete = @visit.job_complete
    @job = @visit.job
    @property = @job.property
    @client = @property.client
  end

#edit visit event
  def edit_visit_event
    @visit = VisitSchedule.find(params[:visit_id])
    @job = @visit.job
    @property = @job.property
    @client = @property.client
    @team_member= current_user.team_members 
    @selected_employee = @visit.crew
    @user_employee = User.find(@selected_employee).collect(&:full_name) rescue ""
  end

#update visit event after edit
  def update_visit_event
    @visit = VisitSchedule.find(params[:visit_id])
    @visit.crew = params[:job][:crew] unless params[:job].blank?
    @visit.update(job_visit_plan_params)
    update_job(params)
    redirect_to events_url
  end

#Destory visit  event
  def destroy_visit_event
    @visit = VisitSchedule.find(params[:visit_id])
    @visit.destroy
    @job = Job.find(params[:job_id])
    @visit_jobs = VisitSchedule.where(:job_id=> @job.id)
    @property = @job.property
    @client = @property.client
    @complete_jobs = @visit_jobs.where(job_complete: true)
    @job_visit = @visit_jobs.where("end_date >= ? AND job_complete = ? ", Date.today, false)
    @job_overdue = @visit_jobs.where("end_date < ? AND job_complete = ? ", Date.today, false)
    redirect_to events_url
  end


  def new_job_event
    if params[:unschedule].blank?
      @start_date = params[:todo][:start_at].to_date
    else
      @start_date = Date.today
    end
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      @jobs = Job.where(:user_id=>user_type_id)
      @invoices=Invoice.where(:user_id=>user_type_id)
    else
      @invoices=Invoice.where(:user_id=>current_user.id)
      @jobs = Job.where(:user_id=>current_user.id )
      @clients = Client.where(:user_id=>current_user.id)
    end
  end

#Search client within list
  def search_job_client
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
  end

  def event_list
  end

  private
    def update_job(params)
      @visit=VisitSchedule.find(params[:visit_id])
      @job=@visit.job
      if !@job.scheduled
        @job.scheduled=true
        @job.start_date=params[:visit_schedule][:start_date]
        @job.end_date=params[:visit_schedule][:end_date]
        @job.save
      end
    end
  #admin json data content events, basic tasks, visit schedules and jobs
    def get_json_data
      @basic_task_admin=[]
      @basic_task_team=[]
      @job_visit=[]
      current_user.basic_tasks.where("start_at_date is not NULL").each do |p|
        if (p.all_day == true)
          p.assigned_to.each do |ass_id|
            @basic_task_admin << { id: p.id, resourceId: ass_id,title: p.title,event_type: p.event_type, :start =>p.start_at_date, :end =>p.end_at_date ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          end
        else
          p.assigned_to.each do |ass_id|
            @basic_task_admin << { id: p.id, resourceId: ass_id,title: p.title,event_type: p.event_type, :start =>( DateTime.new(p.start_at_date.to_date.year, p.start_at_date.to_date.month,p.start_at_date.to_date.day, p.start_at_time.hour,p.start_at_time.min, p.start_at_time.sec) if !p.start_at_time.blank?), :end =>( DateTime.new(p.end_at_date.to_date.year, p.end_at_date.to_date.month,p.end_at_date.to_date.day, p.end_at_time.hour,p.end_at_time.min, p.end_at_time.sec) if !p.end_at_time.blank?) ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          end
        end
      end

      current_user.team_members.where("member_id is not NULL").each do |team|
        user = User.find(team.member_id)
        user.basic_tasks.where("start_at_date is not NULL").each do |p|
          if (p.all_day == true)
            @basic_task_team << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>p.start_at_date, :end =>p.end_at_date ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          else
            @basic_task_team << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>( DateTime.new(p.start_at_date.to_date.year, p.start_at_date.to_date.month,p.start_at_date.to_date.day, p.start_at_time.hour,p.start_at_time.min, p.start_at_time.sec) if !p.start_at_time.blank?), :end =>( DateTime.new(p.end_at_date.to_date.year, p.end_at_date.to_date.month,p.end_at_date.to_date.day, p.end_at_time.hour,p.end_at_time.min, p.end_at_time.sec) if !p.end_at_time.blank?) ,:all_day =>p.all_day,  :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          end
        end
      end

      job_ids = []
      @events = current_user.events.collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => "", :ecolor => "#008000", :message => basic_popup(p)}}
      @jobs_events = get_job_for_calender
      @jobs =  @jobs_events.collect{|p| {title: "#{p[1].count} Jobs", :start => (p[0]if !p[0].blank?), :end => (p[0] if !p[0].blank?), :task_css => "", :ecolor => "#1f518b", :message => job_popup(p)}}
      @job_visits_id = current_user.jobs.where.not(start_date: nil).pluck(:id)
      @visits = VisitSchedule.where(job_id: @job_visits_id)
      @visit_assign_ids = @visits.each{|visit| job_ids << visit.id unless visit.crew.blank?}
      @complete_visit = @visits.where(job_complete: true).collect{|p| {title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}
      @visit_assign = @visits.where(id: @visit_assign_ids, job_complete: false).collect{|p| { id: p.id,title: p.title ,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}
      @visit_assign.each do |visit|
        crews = VisitSchedule.find(visit[:id]).crew
        if !crews.blank?
          crews.each do |p|
            first_name = User.find(p).username
            @job_visit << { id: visit[:id], resourceId: p,title: visit[:title]+"--"+first_name,event_type: visit[:event_type], :start => (visit[:start].to_date.strftime("%Y-%m-%d") if !visit[:start].blank?), :end => (visit[:end].to_date.strftime("%Y-%m-%d") if !visit[:end].blank?), :task_css => (visit[:job_complete] ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup_day(visit)}
          end
        end
      end

      @basic_tasks = @events.concat(@basic_task_admin).concat(@basic_task_team.flatten).concat(@jobs).concat(@complete_visit).concat(@job_visit).to_json
   
    end

#Team member json data content events, basic tasks, visit schedules and jobs
    def get_team_member_data
      
      @job_visit = []
      job_ids = []
      @basic_tasks =[]
      @basic_tasks << @team_member.user.basic_tasks
      @basic_tasks << current_user.basic_tasks
      task_list = get_team_member_task(@basic_tasks.flatten)
      @basic_tasks =  task_list.collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_at_date.strftime("%Y-%m-%d") if !p.start_at_date.blank?), :end => (p.end_at_date.strftime("%Y-%m-%d") if !p.end_at_date.blank?), :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}}.as_json
      @events = @team_member.user.events.collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => "", :ecolor => "#008000", :message => basic_popup(p)}}.as_json
      @jobs_events = get_job_for_calender
      @jobs =  @jobs_events.collect{|p| {title: "#{p[1].count} Jobs", :start => (p[0]if !p[0].blank?), :end => (p[0] if !p[0].blank?), :task_css => "", :ecolor => "#1f518b", :message => job_popup(p)}}.as_json
      @jobs_assigned=[]
      Job.all.each{ |p| @jobs_assigned << p.id if p.crew.include? current_user.id.to_s if !p.crew.blank? }
      # @job_visits_id = current_user.jobs.pluck(:id)
      # 4 feb changes me
      #@visits = VisitSchedule.where(job_id: @jobs_assigned)
    
      @visits = VisitSchedule.all.collect{|p| p if (@jobs_assigned.include?(p.job_id)  && p.crew.include?(current_user.id.to_s))}.compact
     
      @visit_assign_ids = @visits.each{|visit| job_ids << visit.id unless visit.crew.blank?}
      # 4 feb changes me
      #@complete_visit = @visits.where(job_complete: true).collect{|p| {title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}.as_json
      @complete_visit = @visits.collect{|v| v if v.job_complete == true}.compact.collect{|p| {title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}.as_json
     # 4 feb changes me
      #@visit_assign = @visits.where(id: @visit_assign_ids, job_complete: false).collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"),:ecolor => "#0000FF", :message => visit_popup(p)}}
      @visit_assign = @visits.collect{|v| v if (v.job_complete == false)}.compact.collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"),:ecolor => "#0000FF", :message => visit_popup(p)}}
       @visit_assign.each do |visit|
        crews = VisitSchedule.find(visit[:id]).crew
        if !crews.blank?
          crews.each do |p|
            if current_user.id == p.to_i
              first_name = User.find(p).username
              @job_visit << { id: visit[:id], resourceId: p,title: visit[:title]+"--"+first_name,event_type: visit[:event_type], :start => (visit[:start].to_date.strftime("%Y-%m-%d") if !visit[:start].blank?), :end => (visit[:end].to_date.strftime("%Y-%m-%d") if !visit[:end].blank?), :task_css => (visit[:job_complete] ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup_day(visit)}
            end
          end
        end
      end
      @basic_tasks = @events.concat(@basic_tasks).concat(@jobs).concat(@complete_visit).concat(@job_visit).to_json
   
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description,:start_date,:end_date, :start_time, :end_time, :all_day)
    end

    def job_visit_plan_params
      params.require(:visit_schedule).permit(:crew, :any_time, :start_date, :end_date, :job_id, :user_id, :description, :title, :start_time, :end_time, :team_reminder, :completed_by)
    end
end
