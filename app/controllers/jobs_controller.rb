class JobsController < ApplicationController
  include JobsHelper
  load_and_authorize_resource except:[:create,:notice_mail]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:show]

  # GET /jobs
  # GET /jobs.json
  def index
    session[:repeats]=nil
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

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @team_member = current_user.team_members
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Jobs")
    @custom_field_data=@job.custom_field if !@job.custom_field.blank?
    @jobs = Job.where(:user_id=>current_user.id ).count
    @visit_jobs=VisitSchedule.where(:job_id=> @job.id)
    @complete_jobs = @visit_jobs.where(job_complete: true)
    @job_visit = @visit_jobs.where("end_date >= ? AND job_complete = ? ", Date.today, false)
    @job_overdue = @visit_jobs.where("end_date < ? AND job_complete = ? ", Date.today, false)
    @job_unschedule = @visit_jobs.where("start_date is NULL AND end_date is NULL")
    @job.job_works.build if @job.blank?
    @invoices=[]
    @invoice = @job.property.client.invoices
    @property=@job.property
    @invoice.each do |invoice|
      if !invoice.jobs_id.blank?
        invoice.jobs_id.each do |job_id|
          if (@job.id==job_id.to_i)
            @invoices << invoice
          end
        end
      end  
    end 
  end

  # GET /jobs/new
  def new
    if params[:scheduled_task] == "recurring"
      redirect_to recurring_job_jobs_path(:property_id=>params[:property_id])
    end
    @form_partial="one_off_job_form"
    @jobs=Job.where(:user_id=>current_user.id)
    @repeat = Repeat.new
    @team_member = current_user.team_members
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Jobs")
    job_new_url(params) 
  end

  #Create recurring job object
  def recurring_job
    @job= Job.new
    @jobs=Job.where(:user_id=>current_user.id)
    @repeat = Repeat.new
    @team_member = current_user.team_members
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Jobs")
  end

  # GET /jobs/1/edit
  def edit
    @team_member = current_user.team_members
    if @job.repeat.blank?
    @repeat = Repeat.new
    else
      @repeat =@job.repeat
    end
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Jobs")
    @custom_field_data=@job.custom_field if !@job.custom_field.blank?
    @selected_employee = @job.crew
    @user_employee = User.find(@selected_employee).collect(&:full_name) rescue ""
    if @job.job_type== "one_off"
      @form_partial="one_off_job_form"
    else
      @form_partial="recurring_contract_job_form"
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    
    @job = Job.new(job_params)
    recurring_contract_end_date(params)
    if !params[:property_id].nil?
      @job.property_id=params[:property_id]
    end
    session[:value_notify]="true"
    team_user(@job,params)
    respond_to do |format|
      if @job.save
        visit_schedule(params,@job)
        quote_to_job(params,@job)
        # visit_schedule
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

#After create a job its assigned to user
  def team_user(job,params)
    if current_user.user_type=="user"
      user_type_id = TeamMember.find_by_member_id(current_user.id).user_id
      job.user_id = user_type_id
      if params[:job][:crew].blank?
        @crew=[]
        @crew << current_user.id.to_s
        @crew << user_type_id
        job.crew = @crew
      else
        job.crew = params[:job][:crew]
      end  
    else
      job.user_id = current_user.id
      job.crew = params[:job][:crew]
    end
    job.end_date = params[:job][:start_date] if params[:job][:end_date].blank?
    
    job.custom_field=params[:custom_field]
  end

#Create schedule for job
  def visit_schedule(params,job)
    if @job.job_type=="recurring_contract"
      create_recurring_job_visit(@job) 
    else
      create_visit_for_job(@job)
    end  
    if !params[:notify_team].blank?
      notification_mailer(params,@job)
    end
  end

#Create quote works through job
  def quote_to_job(params,job)
    unless params[:job][:quote_id].blank?
      @quote_work = QuoteWork.where(quote_id: params[:job][:quote_id])
      @quote_work.each do |quote_work|
        quotes_convert_to_job(quote_work, job.id)
      end
    end
  end

#Create job and its repeats
  def repeat_job(job)
    if !session[:repeats].blank?
      if job.repeat.blank?
        @repeat = Repeat.new(session[:repeats])
      else
        @repeat=job.repeat
        @repeat.update_attributes(session[:repeats])
      end
      repeat_session_job(@repeat)
      @repeat.job_id = job.id
      @repeat.save
    elsif !@job.repeat.blank?
      if @job.repeat.frequency == (params[:job][:visits])
        @repeat= job.repeat
      else
        job.repeat.delete
      end
    end
    session[:calender_week]=nil
    session[:calender_day]=nil
    session[:day_holder]=nil
    session[:repeats] = nil
  end

#job reapts weekly, monthly 
  def repeat_session_job(repeat)
    if !session[:day_holder].blank?
      if repeat.frequency == "Weekly"
        repeat.day_holder=session[:day_holder] if !session[:day_holder].first.blank?
      else
        repeat.day_holder = ""
      end
    end
    if !session[:calender_day].blank?
      if repeat.frequency == "Monthly" && repeat.monthly_rule_type == "day_of_month"
        repeat.calender_day=session[:calender_day] if !session[:calender_day].first.blank?
      else
        repeat.calender_day = ""
      end
    end
    if !session[:calender_week].blank?
      if repeat.frequency == "Monthly" && repeat.monthly_rule_type == "day_of_week"
        repeat.calander_week=session[:calender_week] if !session[:calender_week].first.blank?
      else
        repeat.calander_week = ""
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    @job.crew = params[:job][:crew]
    @job.custom_field=params[:custom_field]
    recurring_contract_end_date(params)
    if @job.job_type =="recurring_contract"
    else
      params[:job][:end_date] = params[:job][:start_date] if params[:job][:end_date].blank?
    end
    respond_to do |format|
      if @job.update(job_params)
        if @job.job_type =="recurring_contract"
          create_recurring_job_visit(@job)
        else
        create_visit_for_job(@job)
        end
        # visit_schedule
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  #set recurring contract end date
  def recurring_contract_end_date(params)
    if params[:job][:job_type] == "recurring_contract"
      if params[:job][:invoice_type] == "days"
        params[:job][:end_date] = params[:job][:start_date].to_date+1
      elsif params[:job][:invoice_type] == "weeks"
        params[:job][:end_date] = params[:job][:start_date].to_date+7
      elsif params[:job][:invoice_type] == "months"
        params[:job][:end_date] = params[:job][:start_date].to_date+30
      elsif params[:job][:invoice_type] == "years"
        params[:job][:end_date] = params[:job][:start_date].to_date+1.year
      end
    end
  end
   
#Create recurring visit scheduled
  def create_recurring_job_visit(job)
    repeat_job(job)
    if params[:action]=="update"
      job.visit_schedules.delete_all
    end
    if @repeat.blank?
      @start_date= job.start_date
      @count=job.number_of_invoice 
      if job.visits.blank?
        if job.invoice_type=="months"
          while @count > 0 
            type_invoice(@start_date,1,job)
            @count = @count-1
          end      
        elsif job.invoice_type =="days"
          while @count > 6
            type_invoice(@start_date,7,job)
            @count = @count-6
          end   
        elsif job.invoice_type == "weeks"
          while @count > 0
            type_invoice(@start_date,7,job)
            @count = @count-1
          end
        end
      else
         visits_part(job,@start_date)
      end  
    else
      repeat_visit_job(job,@repeat)
    end       
  end

#Create scheduled call methods
  def visits_part(job,start_date)
    if job.visits.start_with? "Weekly"
      weekly_job_visit(job)
    elsif job.visits.start_with? "Monthly"
      monthly_job_visit(job)
    else
      daily_job_visit(job)
    end
  end
 
# after create job its visit schedules created
  def type_invoice(start_date,value,job) 
    @visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
    @visit.title= job.description.truncate(20)
    @visit.crew=job.crew
    @visit.event_type="visit"
    @visit.save
    start_date = @visit.start_date+value.months
  end


  #create visit plan according to job start and end date
  def create_visit_for_job(job)
    start_visit = job.start_date
    end_visit = job.end_date
    if params[:action] == "update"
      @visits = job.visit_schedules.where(job_complete: false).delete_all
    end
    if job.visits == "daily"
      while(start_visit<=end_visit)
        @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
        @visit.title= job.description.truncate(20)
        @visit.crew=job.crew
        @visit.event_type="visit"
        @visit.save
        start_visit += 1
      end
    elsif job.visits == "weekly"
      while(start_visit<=end_visit)
        @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
        @visit.title= job.description.truncate(20)
        @visit.crew=job.crew
        @visit.event_type="visit"
        @visit.save
        start_visit += 7
      end
    elsif job.visits == "monthly"
      while(start_visit<=end_visit)
        @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
        @visit.title= job.description.truncate(20)
        @visit.crew=job.crew
        @visit.event_type="visit"
        @visit.save
        start_visit += 30
      end
    elsif job.visits == "yearly"
      while(start_visit<=end_visit)
        @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
        @visit.start_date = start_visit
        @visit.title= job.description.truncate(20)
        @visit.crew=job.crew
        @visit.event_type="visit"
        @visit.save
        start_visit += 1.year
      end
    else
      @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
      @visit.title= job.description
      @visit.crew=job.crew
      @visit.event_type="visit"
      @visit.save
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Muiltple properties so select properties
  def select_property
    @client=Client.find(params[:client_id])
    @client_properties=@client.properties
  end

  def job_search
    @jobs=Job.where(:user_id=>current_user.id)
  end
  
  def job_sort
    if (params[:sort_by]=="Job Number")|| (params[:sort_by]=="Status")
      @jobs=Job.where(:user_id=>current_user.id)
    else
      @jobs=[]
      current_user.clients.order("#{params[:sort_by]} ASC").each do |client|
        client.properties.each do |property|
          property.jobs.each do |job|
            @jobs << job
          end
        end
      end
    end
  end

#Sort job through its type
  def job_type_sort
    if params[:job_type]== "Recurring"
      @jobs = Job.where(:user_id=>current_user.id ,:job_type=>"recurring_contract")
    elsif params[:job_type] == "One Off Jobs"
      @jobs = Job.where(:user_id=>current_user.id ,:job_type=>"one_off")
    else
      @jobs = Job.where(:user_id=>current_user.id)
    end
  end

#display a jobs its type
  def work
    job_work_tab_contain
    @jobs_archived= archived_job
    @jobs_requires=requires_job
    @job_actives = active_job

     
     # @job=Job.last(2)
     # @invoice=Invoice.last(2)
     # @quote=Quote.last(2)
  end

#Create attachment for the job
  def job_image_upload
    @job=Job.find(params[:job_id])
    @note=Note.new(:job_id=>params[:job_id],:note=>params[:note])
    @note.save
    if !params[:file].blank?
      file_upload(params[:file],@note.id)
    end
    redirect_to @job
  end

#Search job for its job status
  def search_coming_job
    @job = Job.where(:user_id=>current_user.id )
    if params[:job_status]=="all_active"
      @jobs=active_job
    elsif params[:job_status]=="archived"
      @jobs=archived_job
    elsif params[:job_status]== "require_invoice"
      @jobs=requires_job
    else
      late_upcoming_job(params,@job)
    end
  end

#changes job status or updates 
  def status_edit_job
    @job=Job.find(params[:job_id])
    if params[:job_status]=="complete"
      @job.job_complete=true
      @job.job_status= params[:job_status]
      @job.job_required= "Require Invoice"
      @job.complete_on=Date.today.strftime("%Y/%m/%d")
      @job.visit_schedules.update_all(job_complete: true, complete_on: Date.today.strftime("%Y/%m/%d"))
      @job.save
    elsif params[:job_status]=="remove"
      @job.visit_schedules.destroy_all
      @job.job_status = "complete"
      @job.job_required= "Require Invoice"
      @job.job_complete=true
      @job.save
    else
      @visit_schedule=VisitSchedule.find(params[:visit_schedule_id])
      @visit_schedule.job_status = params[:job_status]
      @visit_schedule.job_required= "Require Invoice"
      @visit_schedule.job_complete=true
      @visit_schedule.complete_on=Date.today.strftime("%Y/%m/%d")
      @job.job_status = params[:job_status]
      @job.job_required= "Require Invoice"
      @job.save
      @visit_schedule.save  
    end
    redirect_to @job
  end


#Required edit job method
  def required_edit_job
    @job=Job.find(params[:job_id])
    @job.job_required = params[:require]
    @job.save
    redirect_to @job
  end

# Create and download job pdf
  def job_pdf
    @job=Job.find(params[:job_id])
    @client=Property.find(@job.property_id).client 
    @job_works=@job.job_works
    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => @job.id, :type => 'application/pdf')
  end

#display job and its works
  def job_work
    @work_id = params[:work_id]
    @job=Job.find(params[:job_works][:job_id])
    # @job.update_attributes(job_params)
    @job_work=JobWork.new(job_works)
    @job_work.save
    respond_to do |format|
      format.js
    end
  end

#update job work 
  def job_work_update
    @work_id = params[:work_id]
    @job=Job.find(params[:job_works][:job_id]) unless params[:cancel] == "1"
    @job_work = JobWork.find(params[:job_work_id])
    @job_work.update(job_works) unless params[:cancel] == "1"
  end

#destroy job_work
  def job_work_destroy
    @job_work = JobWork.find(params[:job_work_id])
    @job_work.destroy
  end

#Add signature and generate pdf with this signature
  def attach_client_sign
    @job=Job.find(params[:job_id])
    instructions = JSON.parse(params[:output]).map { |h| "line #{h['mx'].to_i},#{h['my'].to_i} #{h['lx'].to_i},#{h['ly'].to_i}" } * ' '
      tempfile = Tempfile.new(["signature",".png"], "#{Rails.root.to_s}/tmp/")
      Open3.popen3("convert -size 198x55 xc:transparent -stroke blue -draw @- #{tempfile.path}") do |input, output, error|
          input.puts instructions
      end
      @note=Note.create(:job_id=>params[:job_id],:note=>params[:note])
      @note.attachments.create(:image=>tempfile)
      
        FileUtils.mkdir_p "#{Rails.public_path}/signature"
          @upload = File.open(Rails.root.join('public/signature',"#{current_user.id}.png"), 'w') do |file|
           file.write(tempfile.read)
          end

        html = render_to_string(:layout => false )
        kit = PDFKit.new(html, :page_size => 'Letter')
        @attach=@note.attachments.last
        
        thepdf= kit.to_file("#{Rails.root}/tmp/signature.pdf")
        @attach.image=thepdf
        @attach.save
        FileUtils.rm_rf("#{Rails.public_path}/signature/#{current_user.id}.png")
      redirect_to  @job
  end

#Generate job invoice
  def genrate_job_invoice
    if params[:client_id].blank?
      @client=Job.find(params[:job_id]).property.client
    else
      @client=Client.find(params[:client_id])
    end
    @jobs=[]
    if !@client.properties.blank?
      @client.properties.each do |property|
        if !property.jobs.blank?
          property.jobs.each do |job|
            @jobs << job
          end
        end
      end
    end
    if @jobs.blank?
      redirect_to new_invoice_path(client_id: params[:client_id])
    end
  end

#Job completed 
  def job_completed
    @visit_schedule=VisitSchedule.find(params[:visit_schedule_id])
    if params[:job_type]== "false"
      @visit_schedule.job_complete = false
    else  
      @visit_schedule.job_complete = true
      @visit_schedule.completed_by = params[:completed_by]
      @visit_schedule.complete_on = Date.today.strftime("%Y/%m/%d")
    end
    @visit_schedule.save
    @job=Job.find(@visit_schedule.job_id)
    @visit_jobs=VisitSchedule.where(:job_id=> @job.id)
    @complete_jobs = @visit_jobs.where(job_complete: true)
    @job_visit = @visit_jobs.where("end_date >= ? AND job_complete = ? ", Date.today, false)
    @job_overdue = @visit_jobs.where("end_date < ? AND job_complete = ? ", Date.today, false)
    @all_job_complete = "#all_job_complete" if @job_visit.blank?
  end

#Job vist plan
  def job_visit_plan
    @job=Job.find(params[:job_id])
    @visit_schedule=VisitSchedule.new( :any_time=>params[:any_time],:start_date=>params[:start_date],:end_date=>params[:end_date],:job_id=>params[:job_id],:user_id=>current_user.id,:description=>params[:description],:title=>params[:visit_name]) if (params[:all_day]=="on")
    @visit_schedule=VisitSchedule.new( :any_time=>params[:any_time],:start_date=>params[:start_date],:end_date=>params[:end_date],:start_time=>params[:start_time],:end_time=>params[:end_time],:job_id=>params[:job_id],:user_id=>current_user.id,:description=>params[:description],:title=>params[:visit_name]) if (params[:all_day]!="on")
    @visit_schedule.crew=@visit_schedule.params[:job][:crew] if !params[:job][:crew].first.blank?
    @visit_schedule.save
    redirect_to @job
  end

#check if visit start and end date not in job date
  def schedule_job_for_visit(job, params)
    job.start_date = params[:start_date] if job.start_date > params[:start_date].to_date
    job.end_date = params[:end_date] if job.end_date < params[:end_date].to_date
    job.save
  end

#Edit visit plan
  def edit_visit_plan
    @visit = VisitSchedule.find(params[:visit_id])
    @job = @visit.job
    @property = @job.property
    @client = @property.client
  end

# Update visit plan
  def update_visit_plan
    @visit = VisitSchedule.find(params[:visit_id])
    @visit.crew = params[:job][:crew]
    @visit.update(job_visit_plan_params)
  end

#Destory visit plan
  def destroy_visit_plan
    @visit = VisitSchedule.find(params[:visit_id])
    @visit.destroy
    @job = Job.find(params[:job_id])
    @visit_jobs = VisitSchedule.where(:job_id=> @job.id)
    @property = @job.property
    @client = @property.client
    @complete_jobs = @visit_jobs.where(job_complete: true)
    @job_visit = @visit_jobs.where("end_date >= ? AND job_complete = ? ", Date.today, false)
    @job_overdue = @visit_jobs.where("end_date < ? AND job_complete = ? ", Date.today, false)
  end

  def get_edit_job
    params[:index] = "job_work_#{params[:index]}"
    @job_work = JobWork.find(params[:job_work_id])
  end

  #repeat job info on create job
  def repeat
    session[:repeats] = params[:repeat]
    session[:day_holder] = params[:day_holder]
    session[:calender_day] = params[:calender_day]
    session[:calender_week] = params[:calander_week]
  end

  def notice_mail
    session[:set_job_url]="/jobs/#{params[:id]}"
    redirect_to root_url 
  end

  #for change form on select type
  def job_form_change
    @jobs=Job.where(:user_id=>current_user.id)
    @repeat = Repeat.new
    @team_member = current_user.team_members
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Jobs")
    job_new_url(params) 
    @job_form = "one_off_job_form" if params[:job_type] == "one_off"
    @job_form = "recurring_contract_job_form" if params[:job_type] == "recurring_contract"
  end

  def job_assigned_visit
    @visit = VisitSchedule.find(params[:visit_id])
    @visit_complete = @visit.job_complete
    @job = @visit.job
    @property = @job.property
    @client = @property.client
  end

  def get_end_date
    @start_date=params[:st_date].to_date
    if params[:type] == "days"
      @date = @start_date+ params[:number].to_i.days
    elsif params[:type] == "months"
      @date = @start_date + params[:number].to_i.months
    elsif params[:type]== "weeks"
      @date = @start_date + params[:number].to_i.weeks
    end    
    @date=@date.to_s
  end

  private
  def active_job
    @jobs_active=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job| 
      if job.job_required!= "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if ((@count== 0) || (job.start_date == Date.today)) 
            @jobs_active<< job 
          end
        end
      end
      return @jobs_active
    end  
  end

  def requires_job
    @jobs_required=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job|
        if job.job_required== "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if @count== 0
            @jobs_required<< job
          end
        end
      end
      return @jobs_required
    end  
  end

  def archived_job
    @jobs_archives=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job|
        if job.job_required== "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if @count!= 0
            @jobs_archives<< job
          end
        end
      end
      return @jobs_archives
    end  
  end

  def file_upload(params,note)
    params.each do |file|
      @attachment=Attachment.new(:image=>file,:note_id=>note)
      @attachment.save
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  #quotes convert to job from quotes
  def quotes_convert_to_job(quote_work,job_id)
    quote_work.name.each_with_index do |work,index|
      @job_work = JobWork.new
      @job_work.name = quote_work.name[index]
      @job_work.description = quote_work.description[index]
      @job_work.quantity = quote_work.quantity[index]
      @job_work.unit_cost = quote_work.unit_cost[index]
      @job_work.total = quote_work.total[index]
      @job_work.job_id = job_id
      @job_work.save
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:description, :scheduled, :start_date, :end_date, :visits, :start_time, :end_time, :invoicing, :invoice_period, :first_invoice_on,:job_type,:number_of_invoice,:invoice_type, :quote_id, :crew,:job_order)
  end

  def job_works
    params.require(:job_works).permit(:name,:description,:quantity,:unit_cost,:total,:job_id)
  end

  #repeats params for job
  def repeat_params
    params.require(:repeat).permit(:frequency, :daily_interval, :weekly_interval, :day_holder, :monthly_interval, :monthly_rule_type, :calender_day, :calander_week, :yearly_interval, :invoicing, :visits, :job_id)
  end

  def job_visit_plan_params
    params.require(:visit_schedule).permit(:crew, :any_time, :start_date, :end_date, :job_id, :user_id, :description, :title, :start_time, :end_time, :team_reminder, :completed_by)
  end
end
