class BasicTasksController < ApplicationController
  include EventsHelper
	include BasicTasksHelper
  include JobsHelper
	before_action :authenticate_user!

#Display schedule view basic tasks, jobs ,visit schedules and events 
  def index
    @jobs = Job.where(:user_id=>current_user.id)
    @clients = Client.where(:user_id=>current_user.id)
    @event = Event.new
    if current_user.user_type == "admin"
      get_json_data
    else
      get_team_member_data
    end

    @users = []
    @users << {id: "#{current_user.id}", title: "#{current_user.full_name}" ,eventColor: "##{current_user.marker_color}"}
    current_user.team_members.where("member_id is not NULL").each do |team|
      user=User.find(team.member_id)
      @users  << {id: "#{user.id}" , title: "#{user.full_name}",eventColor: "##{user.marker_color}"}
    end
  end

#New Basic task modal popup
  def to_dos
    @start_at = params[:todo][:start_at].to_date if !params[:todo].blank?
    @end_at = params[:todo][:end_at].to_date if !params[:todo].blank?
    @basic_task = current_user.basic_tasks.new
    if current_user.user_type == "admin"
      @members = current_user.team_members
    end
  end

#Basic task created
	def create
		@basic_task = current_user.basic_tasks.create(basic_task_params)
    if params[:basic_task][:assigned_to].blank?
      @basic_task.assigned_to= (current_user.id).to_s.split()
    else
      @basic_task.assigned_to=params[:basic_task][:assigned_to]
    end
    @basic_task.property_id=params[:property_id]
    @basic_task.event_type ="basic"

    respond_to do |format|
      if @basic_task.save
        format.html { redirect_to events_path}
        format.json { render :show, status: :created, location: @basic_task }
      else
        format.html { render :new }
        format.json { render json: @basic_task.errors, status: :unprocessable_entity }
      end
    end
 	end

# GET /basic_tasks/1
# GET /basic_tasks/1.json
  def show
    if current_user.user_type == "admin"
      @unschdule_tasks=current_user.basic_tasks.where(:start_at_date=>nil,:end_at_date=>nil,:is_completed=>false)
      get_json_data
    else
      @unschdule_tasks=[]
      @basic_task_un=current_user.basic_tasks.where(:is_completed=>false,:start_at_date=>nil,:end_at_date=>nil)
      @basic_task_un.each {|p| @unschdule_tasks << p if p.assigned_to.include? current_user.id.to_s }
      get_team_member_data
    end
  end

#for view detail
  def view_detail
  	@basic_task = BasicTask.find(params[:basic_task_id])
  	@user = User.find(@basic_task.complete_by).full_name unless @basic_task.complete_by.blank?
  end

# GET /basic_tasks/new
  def new
    if current_user.user_type == "admin"
  	  @members = current_user.team_members
    else
      @members = TeamMember.where(user_id: @team_member.user_id)
    end
    @basic_task = BasicTask.new
  end

# GET /basic_tasks/1/edit
  def edit
    if current_user.user_type == "admin"
      @members = current_user.team_members
    end
  	@basic_task = BasicTask.find(params[:id])
  	@start_at = @basic_task.start_at_date 
  	@end_at = @basic_task.end_at_date 
    @selected_employee =  @basic_task.assigned_to
    @user_employee = User.find(@selected_employee).collect(&:full_name) rescue ""
  end

#Basic task update
  def update
  	@basic_task =BasicTask.find(params[:id])
  	@basic_task.update(basic_task_params)
    @basic_task.assigned_to= params[:basic_task][:assigned_to]
    #@basic_task.assigned_to<<params[:assigned_to]
    @basic_task.save
  	redirect_to @basic_task
  end

#Basic task destory
  def destroy
  	@basic_task = BasicTask.find(params[:id])
  	@basic_task.delete
  	redirect_to events_url
  end

#Basic task radio button checked
	def complete_basic_task
		@basic_task = BasicTask.find(params[:basic_task_id])
		completed = params[:basic_task][:is_completed].blank? ? false : true
		@basic_task.update(is_completed: completed, complete_by: params[:basic_task][:complete_by], completed_date: params[:basic_task][:completed_date])
    if current_user.user_type == "admin"
      @unschdule_tasks=current_user.basic_tasks.where(:start_at_date=>nil,:end_at_date=>nil,:is_completed=>false)
      get_json_data
    else
      @unschdule_tasks=[]
      @basic_task_un=current_user.basic_tasks.where(:is_completed=>false,:start_at_date=>nil,:end_at_date=>nil)
      @basic_task_un.each {|p| @unschdule_tasks << p if p.assigned_to.include? current_user.id.to_s }
      get_team_member_data
    end
	end

#Drag and drop events
  def move
    if params[:event_type] =="task_event"
      @basic_task=BasicTask.find(params[:id]) rescue ""
      if !@basic_task.blank?
        @basic_task.start_at_date = params[:start_date].to_date.strftime("%Y-%m-%d")
        @basic_task.end_at_date = params[:end_date].to_date.strftime("%Y-%m-%d")
        @basic_task.save
      end
    else
      moved_job(params)
    end
  end

#Drag and drop job and its scheduled
  def moved_job params
    @visit_schedule=VisitSchedule.find(params[:id]) rescue ""
    if !@visit_schedule.blank?
      @visit_schedule.start_date = params[:start_date].to_date.strftime("%Y-%m-%d")
      @visit_schedule.end_date = params[:end_date].to_date.strftime("%Y-%m-%d")
      @visit_schedule.save
      @job = @visit_schedule.job
      @job.start_date = params[:start_date].to_date.strftime("%Y-%m-%d")
      @job.end_date = params[:end_date].to_date.strftime("%Y-%m-%d")
      @job.scheduled = true
      @job.save
    end
  end


	private

  #get all data as json format for admin
    def get_json_data
      @basic_task=[]
      @basic_tasks=[]
      current_user.basic_tasks.where("start_at_date is not NULL").each do |p|
        if (p.all_day == true)
          @basic_tasks << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>p.start_at_date, :end =>p.end_at_date ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
        else
          @basic_tasks << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>( DateTime.new(p.start_at_date.to_date.year, p.start_at_date.to_date.month,p.start_at_date.to_date.day, p.start_at_time.hour,p.start_at_time.min, p.start_at_time.sec) if !p.start_at_time.blank?), :end =>( DateTime.new(p.end_at_date.to_date.year, p.end_at_date.to_date.month,p.end_at_date.to_date.day, p.end_at_time.hour,p.end_at_time.min, p.end_at_time.sec) if !p.end_at_time.blank?) ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
        end
      end

      current_user.team_members.where("member_id is not NULL").each do |team|
        user = User.find(team.member_id)
        user.basic_tasks.where("start_at_date is not NULL").each do |p|
          if (p.all_day == true)
            @basic_task << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>p.start_at_date, :end =>p.end_at_date ,:all_day =>p.all_day, :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          else
            @basic_task << { id: p.id, resourceId: p.user_id,title: p.title,event_type: p.event_type, :start =>( DateTime.new(p.start_at_date.to_date.year, p.start_at_date.to_date.month,p.start_at_date.to_date.day, p.start_at_time.hour,p.start_at_time.min, p.start_at_time.sec) if !p.start_at_time.blank?), :end =>( DateTime.new(p.end_at_date.to_date.year, p.end_at_date.to_date.month,p.end_at_date.to_date.day, p.end_at_time.hour,p.end_at_time.min, p.end_at_time.sec) if !p.end_at_time.blank?) ,:all_day =>p.all_day,  :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500", :message => task_popup(p)}
          end
        end
      end
      @events = current_user.events.collect{|p| {id: p.id,title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => "", :ecolor => "#008000", :message => basic_popup(p)}}     
      job_ids = []
      @jobs_events = get_job_for_calender
      @jobs =  @jobs_events.collect{|p| {title: "#{p[1].count} Jobs", :start => (p[0]if !p[0].blank?), :end => (p[0] if !p[0].blank?), :task_css => "", :ecolor => "#B87333", :message => job_popup(p)}}
      @job_visits_id = current_user.jobs.pluck(:id)
      @visits = VisitSchedule.where(job_id: @job_visits_id)
      @visit_assign_ids = @visits.each{|visit| job_ids << visit.id unless visit.crew.blank?}
      @complete_visit = @visits.where(job_complete: true).collect{|p| {title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}
      @visit_assign = @visits.where(id: @visit_assign_ids, job_complete: false).collect{|p| { id: p.id, title: p.title,event_type: p.event_type, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}
      @basic_tasks = @events.concat(@basic_tasks).concat(@basic_task.flatten).concat(@jobs).concat(@complete_visit).concat(@visit_assign)
    end

  #get all data as json format for team members
    def get_team_member_data
      job_ids = []
      @events = current_user.events.collect{|p| {id: p.id,event_type: p.event_type,title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => "", :ecolor => "#008000", :message => basic_popup(p)}}
      @basic_tasks = BasicTask.all
      task_list = get_team_member_task(@basic_tasks)
      @basic_tasks =  task_list.collect{|p| {id: p.id,event_type: p.event_type,title: p.title, :start => (p.start_at_date.strftime("%Y-%m-%d") if !p.start_at_date.blank?), :end => (p.end_at_date.strftime("%Y-%m-%d") if !p.end_at_date.blank?), :task_css => (p.is_completed ? "line-through" : "none"), :ecolor => "#FF4500",:message => task_popup(p)}}
      @jobs_events = get_job_for_calender
      @jobs =  @jobs_events.collect{|p| {title: "#{p[1].count} Jobs", :start => (p[0]if !p[0].blank?), :end => (p[0] if !p[0].blank?), :task_css => "", :ecolor => "#B87333", :message => job_popup(p)}}
      @jobs_assigned=[]
      Job.all.each{ |p| @jobs_assigned << p.id if p.crew.include? current_user.id.to_s if !p.crew.blank? }
      @visits = VisitSchedule.where(job_id: @jobs_assigned)
      @visit_assign_ids = @visits.each{|visit| job_ids << visit.id unless visit.crew.blank?}
      @complete_visit = @visits.where(job_complete: true).collect{|p| {title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"), :ecolor => "#0000FF", :message => visit_popup(p)}}
      @visit_assign = @visits.where(id: @visit_assign_ids, job_complete: false).collect{|p| {id: p.id, event_type: p.event_type,title: p.title, :start => (p.start_date.strftime("%Y-%m-%d") if !p.start_date.blank?), :end => (p.end_date.strftime("%Y-%m-%d") if !p.end_date.blank?), :task_css => (p.job_complete ? "line-through" : "none"),:ecolor => "#0000FF", :message => visit_popup(p)}}
    
      @basic_tasks = @events.concat(@basic_tasks).concat(@jobs).concat(@complete_visit).concat(@visit_assign)
    end

		def basic_task_params
	    params.require(:basic_task).permit(:title, :description,:start_at_date,:end_at_date, :start_at_time, :end_at_time, :all_day, :repeat, :is_completed, :complete_by, :completed_date, :assigned_to)
	  end
end
