module JobsHelper
  def get_user_assigned(user_id)
    return User.find(user_id).username rescue ""
  end

  def get_company_address(user)
    user=TeamMember.find_by_member_id(user.id).user_id
    @user= User.find(user)
    return @user.company rescue ""
  end

  def get_start_points(user,params)
    if params[:start_point].include? "user_"
      return "#{user.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.city}, #{user.state}, #{user.zipcode}"
    elsif user.user_type == "admin"
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    else
      team=TeamMember.find_by_member_id(user.id).user_id
      user= User.find(team)
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    end
  end

  def get_end_points(user,params)
    if params[:end_point].include? "user_"
      return "#{user.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.city}, #{user.state}, #{user.zipcode}"
    elsif user.user_type == "admin"
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    else
      team=TeamMember.find_by_member_id(user.id).user_id
      user= User.find(team)
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    end
  end

  def get_multipoints(params,user)
    if user.user_type == "admin"
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    else
      team=TeamMember.find_by_member_id(user.id).user_id
      user= User.find(team)
      return "#{user.company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{user.company.city}, #{user.company.state}, #{user.company.zipcode}"
    end
  end
  def end_date_month_job
    return Date.today.at_end_of_month.strftime("%d/%m/%Y") rescue ""
  end

  def get_weekly_day(job)
    @days=[]
    job.repeat.day_holder.first.split(",").each do |day|
      @days << days_full(day)
    end
    return @days
  end

  def get_select_week_display(repeat,value)
    if !repeat.day_holder.blank?
      if repeat.day_holder.first.split(",").include? value.to_s
        return "selected"
      else
        return ""
      end
    end  
  end

  def get_summary(repeat)
    if repeat.frequency == "Weekly" && !repeat.day_holder.first.blank?
      @days=[]
      repeat.day_holder.first.split(",").each do |day|
        @days << days_full(day)
      end
      return "Weekly on " + @days.join(",")
    elsif repeat.frequency == "Weekly" && repeat.day_holder.first.blank?
      return " Summary : Weekly"
    end  

  end

  def find_address_temperature(temp)
    return ((temp.to_f *  9/5) + 32) rescue ""
  end
  def find_current_temperature(barometer)
    return ((barometer.current.temperature *  9/5) + 32) rescue ""
  end
  
  def find_temperature(weather)
    return (((weather.responses.first.current.temperature.to_f)*9/5)+32) rescue ""
  end

  def find_current_weather(coordinates)
    return Geocoder.search(coordinates).first
  end

  def find_current_address(ip_address)
    return Barometer::Query.new(ip_address)
  end

  def query_for_lat_long(ip_address)
    # Calling LatLongService for fetching lat long 
    lat_long_service = LatLongService.new(:ip=>ip_address)
    lat_long = lat_long_service.fetch
    lat = lat_long[:lat]
    lon = lat_long[:lon]
    return Barometer::Query.new("#{lat},#{lon}")
  end

  def find_current_barometer(query,keys)
    return Barometer::ForecastIo.call(query, keys: keys)
  end
  
  def current_barometer
    keys = {api: '9027ce61acb3e40733cb4173b5bd2124'}
    begin
      query = find_current_address(Rails.env== "development" ? "122.168.204.0" : request.remote_ip)
      return find_current_barometer(query, keys)
    rescue
      query = query_for_lat_long(Rails.env == "development" ? "122.168.204.0" : request.remote_ip)
      return find_current_barometer(query, keys)
    end
  end
  
  def job_popup(p)
    return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>Job for #{p[0]}</div></div><div class='content'><p>Total job: #{p[1].count}</p><a href='' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>Show Grid View</a></div></div><div class='arrow'></div></div>".html_safe
  end

  def job_requires_amount_show(job)
    if !job.job_works.blank?
      @requires_amount=0
      job.job_works.each do |job_work|
        @requires_amount= @requires_amount + job_work.try(:total) unless job_work.blank? rescue 0
      end
      return @requires_amount
    end
  end

  def job_archived_amount(jobs_archived)
    if !jobs_archived.blank?
      @archived_amount=0
      jobs_archived.each do|job_archived| 
        if !job_archived.job_works.blank?
          job_archived.job_works.each do |job_work|
            @archived_amount= @archived_amount+ job_work.try(:total)
          end
        end
      end
      return @archived_amount
    end 
  end

  def property_name_list(job)
    @property=job.property
    return @property.try(:street)+ " / " + @property.try(:city) + " , "+@property.try(:state) +" "+ @property.try(:zipcode)
    
  end

  def job_property_client(job)
    @client=job.property.client
    return @client.try(:initial) +" "+ @client.first_name + @client.last_name
  end

  def late_upcoming_job(params,job)
    @job=job
    @jobs=[]
    if params[:job_status]=="late"
      @job.each do |job|
        if job.job_status.nil?
          if !job.end_date.nil? && ((job.end_date < Date.today))
            @jobs<< job
          elsif job.start_date < Date.today
            @jobs << job
          end
        end
      end
    elsif params[:job_status]=="upcoming"
      @job.each do |job|
        if job.start_date > Date.today
          @jobs << job
        end 
      end
    elsif params[:job_status]=="today"
      @job.each do |job|
        if job.start_date == Date.today
          @jobs << job
        end 
      end
    elsif params[:job_status]=="action_required"
      @job.each do |job|
        if !job.job_status.nil?
          if job.job_required!= "Require Invoice"
            @jobs<< job
          end
        end    
      end
    else
      @jobs=@job
    end
  end

  def check_job_invoice_genrate(job)
    @invoices=Invoice.where(:user_id=>current_user.id)
    @count=0
    if !@invoices.blank?
      @invoices.each do |invoice|
        if !invoice.jobs_id.blank? 
          if invoice.jobs_id.include? job.id.to_s
            @count=@count+1
          end
        end
      end
    end
    return @count
  end

  def repeat_visit_job(job,repeat)
    if repeat.frequency == "Weekly"
      count=job.number_of_invoice*7 if job.invoice_type == "weeks"
      count=job.number_of_invoice if job.invoice_type == "days"
      count= find_invoice_month(job) if job.invoice_type == "months"
      if !repeat.day_holder.blank?
        start_date=job.start_date
        end_date =job.start_date + count.to_i.days
        while (start_date < end_date)
          sta_date= start_date
          while(sta_date < start_date + 7.days)
            if !repeat.day_holder.blank?
              repeat.day_holder.first.split(",").each do |num|
                day = days_display(sta_date.strftime("%a"))
                if num == day
                  visit = job.visit_schedules.new(start_date: sta_date, end_date: sta_date)
                  visit.title= job.description.truncate(20)
                  visit.crew=job.crew
                  visit.event_type ="visit"
                  visit.save
                end 
              end
            end   
            sta_date=sta_date + 1.days
          end
          interval = repeat.weekly_interval
          if ((interval=="1") || (interval.nil?))
            start_date=start_date + 7.days
          else
            start_date=start_date + (interval*7).days
          end  
        end              
      end
    elsif repeat.frequency == "Daily"
      count=job.number_of_invoice*7 if job.invoice_type == "weeks"
      count=job.number_of_invoice if job.invoice_type == "days"
      count= find_invoice_month(job) if job.invoice_type == "months"
      start_date= job.start_date
      while count > 0
        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
        visit.title= job.description.truncate(20)
        visit.crew=job.crew
        visit.event_type ="visit"
        visit.save
        interval= repeat.daily_interval
        if ((interval == "1") || (interval.nil?))
          start_date = visit.start_date+7.days
          count = count-1
        else
          start_date =visit.start_date+ interval.days
          count = count-interval
        end 
      end   
    elsif repeat.frequency == "Monthly"    
      if repeat.monthly_rule_type == "day_of_month"
        count=job.number_of_invoice
        if job.invoice_type == "days"
          interval= repeat.daily_interval
          monthly_daily(count,job,interval,repeat)
        elsif job.invoice_type == "weeks"
          interval= repeat.weekly_interval
          monthly_daily(count*7,job,interval,repeat)
        elsif job.invoice_type == "months"
          interval= repeat.monthly_interval
          check_day = find_invoice_month(job)
          monthly_daily(check_day,job,interval,repeat) 
        end
      else
        count=job.number_of_invoice if job.invoice_type == "days"
        count=(job.number_of_invoice)*7 if job.invoice_type == "weeks"
        count= find_invoice_month(job) if job.invoice_type == "months"
        
        interval = @repeat.monthly_interval if @repeat.frequency == "Monthly"
        interval = @repeat.daily_interval if @repeat.frequency == "Daily"
        interval = @repeat.weekly_interval if @repeat.frequency == "Weekly"
        start_date = job.start_date
        @count=job.number_of_invoice if job.invoice_type == "days"
        @count=(job.number_of_invoice)*7 if job.invoice_type == "weeks"
        @count= find_invoice_month(job) if job.invoice_type == "months"
        j_val=0
        while count > 0
          
          if j_val==0
            start_date1= start_date.at_beginning_of_month
          elsif j_val != 0 and interval == 1
            start_date1= start_date.at_beginning_of_month+1.months
          else
            start_date1= start_date.at_beginning_of_month+interval.months
          end
          @repeat.calander_week.first.split(",").each do |week|
            week.split("-").each_with_index do |day,index|
              @instance_week=day if index == 0
              if index==1
                @days=find_month(day)
                i=0
                while i < 7  do
                  date_job = (start_date1+i).strftime("%A")
                  start_date = start_date1+i
                  val_date = start_date if @instance_week == "1"
                  val_date = start_date + 7.days if @instance_week == "2"
                  val_date = start_date + 14.days if @instance_week == "3"
                  val_date = start_date + 21.days if @instance_week == "4"

                  if job.start_date+@count > val_date
                    if date_job == @days
                      if @instance_week == "1"
                        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
                      elsif @instance_week == "2"
                        start_date= start_date+7.days
                        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
                      elsif @instance_week == "3"
                        start_date= start_date+14.days
                        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
                      elsif @instance_week == "4"
                        start_date= start_date+21.days
                        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
                      end  
                      visit.title= job.description.truncate(20)
                      visit.crew=job.crew
                      visit.event_type ="visit"
                      visit.save
                    end
                  end  
                  i +=1
                end  # END OF WHILE i LOOP
              end # END OF INDEX LOOP
            end # END of week LOOP
          end # END OF REPEAT CALENDER WEEK LOOP
          count= count - interval*30
          j_val+=1
        end   # END WHILE count LOOP  
        visit_first_created(job)
      end # END OF DAY OF WEEKS LOOP 
    end # END OF REPEAT MONTH FREQUENCY 
  end # END OF METHOD REPEAT VISIT JOB
  
  def visit_first_created(job)
      interval = @repeat.monthly_interval if @repeat.frequency == "Monthly"
      interval = @repeat.daily_interval if @repeat.frequency == "Daily"
      interval = @repeat.weekly_interval if @repeat.frequency == "Weekly"
    if @job.visit_schedules.blank?
      start_date = @job.start_date
      start_date1= start_date.at_beginning_of_month
      @job.repeat.calander_week.first.split(",").first.split("-").each_with_index do |day,index|
        @instance=day if index == 0
        if index==1
          days=find_month(day)
          i=0 
          while i < 7  do
            date_job = (start_date1+i).strftime("%A")
            start_date = start_date1+i
            if date_job == days
              if @instance == "1"
                visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
              elsif @instance == "2"
                start_date= start_date+7.days
                visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
              elsif @instance == "3"
                start_date= start_date+14.days
                visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
              elsif @instance == "4"
                start_date= start_date+21.days
                visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
              end  
              visit.title= job.description.truncate(20)
              visit.crew=job.crew
              visit.event_type ="visit"
              visit.save
            end
            i +=1
          end
        end
      end
    end
  end
  
  def monthly_daily(count,job,interval,repeat)
    start_date = job.start_date
    remain=0
    while count > 0
      month_interval= repeat.monthly_interval.blank? ? 1 : repeat.monthly_interval.months
      start_date1 = start_date.at_beginning_of_month
      repeat.calender_day.first.split(",").each_with_index do |cal,index|

        start_date = start_date1 + cal.to_i-1.days
        if job.invoice_type == "days"
          if job.start_date+job.number_of_invoice.to_i > start_date 
            visit_interval_generate(job,start_date)
          elsif index == 0
            new_visit_interval_generate(job,start_date)
          end
        elsif job.invoice_type == "weeks"
          if job.start_date+job.number_of_invoice*7 > start_date
            visit_interval_generate(job,start_date)
          elsif index == 0
            new_visit_interval_generate(job,start_date)
          end   
        else
          if job.start_date + find_invoice_month(job) > start_date
            visit_interval_generate(job,start_date)
          elsif index == 0
            new_visit_interval_generate(job,start_date)
          end
        end
      end 
      start_date = start_date + month_interval
      count= count-30
    end
  end


  def visit_interval_generate(job,start_date)
    visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
    visit.title= job.description.truncate(20)
    visit.crew=job.crew
    visit.event_type ="visit"
    visit.save
  end

  def new_visit_interval_generate(job,start_date)
    if job.visit_schedules.blank?
      visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
      visit.title= job.description.truncate(20)
      visit.crew=job.crew
      visit.event_type ="visit"
      visit.save
    end
  end

  def days_display(job)
    case job
      when "Sun"
        return "0"
      when "Mon"
        return "1"
      when "Tue" 
        return "2"
      when "Wed"  
        return "3"
      when "Thu"
        return "4"
      when "Fri"    
        return "5"
    else
      return "6"
    end
  end


  def find_month(day)
    case day
      when "0"
        return "Sunday"
      when "1"
        return "Monday"
      when "2" 
        return "Tuesday"
      when "3"  
        return "Wednesday"
      when "4"
        return "Thursday"
      when "5"    
        return "Friday"
    else
      return "Saturday"
    end
  end


  def days_full(day)
    case day
      when "0"
        return "Sunday"
      when "1"
        return "Monday"
      when "2" 
        return "Tuesday"
      when "3"  
        return "Wednesday"
      when "4"
        return "Thursday"
      when "5"    
        return "Friday"
      else
        return "Saturday"
      end
  end


  def weekly_job_visit(job)
    start_date = job.start_date
    job_day = job.start_date.strftime("%A")+"s"
    check_day = job.number_of_invoice if job.invoice_type == "days"
    check_day = job.number_of_invoice*7 if job.invoice_type == "weeks"
    check_day = find_invoice_month(job)  if job.invoice_type == "months"
    visit_day = job.visits.gsub("Weekly on ","")
    while check_day >0
      if job_day == visit_day
        start_date = start_date
        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
        visit.title= job.description.truncate(20)
        visit.crew=job.crew
        visit.event_type ="visit"
        visit.save 
        check_day= check_day-7
        start_date=start_date+7.days
      else
        check_day = check_day -1
        start_date=start_date+1.days
      end
    end
  end 

  def find_invoice_month(job)     
    current_days=job.start_date.at_end_of_month.strftime("%d").to_i- job.start_date.strftime("%d").to_i
    check_day=current_days
    st_point = 1
    num = job.number_of_invoice.to_i
    while st_point <= num  do
      start_date12= job.start_date+st_point.months
      day_we = start_date12.at_end_of_month.strftime("%d")
      check_day =check_day + day_we.to_i
      st_point +=1
    end
    check_day= check_day - current_days
  end

  def monthly_job_visit(job)
    start_date=job.start_date
    check_day = job.number_of_invoice if job.invoice_type == "days"
    check_day = job.number_of_invoice*7 if job.invoice_type == "weeks"
    check_day = find_invoice_month(job)  if job.invoice_type == "months"
    day_visit = job.start_date.strftime("%d").to_i
    while check_day > 0
      start_date = start_date
      visit_day= start_date.strftime("%d").to_i
      if day_visit == visit_day
        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
        visit.title= job.description.truncate(20)
        visit.crew=job.crew
        visit.event_type ="visit"
        visit.save 
        check_day = check_day-1
        start_date=start_date+1.days
      else
        check_day = check_day-1
        start_date=start_date+1.days
      end  
    end
  end
  
  def display_day(job)
    @days=[]
    if !job.repeat.day_holder.blank?  
      job.repeat.day_holder.first.split(",").each do |day|
        @days << days_full(day)
      end
    end
    return @days
  end

  def get_day_of_month(job)
    @day_month=[]
    if !job.repeat.calender_day.blank?
      job.repeat.calender_day.first.split(",").each do |day|
        @day_month << day + get_suffix(day) 
      end
    end
    return @day_month
  end

  def daily_job_visit(job)
    start_date = job.start_date
    check_day = job.number_of_invoice if job.invoice_type == "days"
    check_day = job.number_of_invoice*7 if job.invoice_type == "weeks"
    check_day = find_invoice_month(job)  if job.invoice_type == "months"
    while check_day > 0
        start_date = start_date
        visit = job.visit_schedules.new(start_date: start_date, end_date: start_date)
        visit.title= job.description.truncate(20)
        visit.crew=job.crew
        visit.event_type ="visit"
        visit.save 
        check_day= check_day-job.repeat.daily_interval
        start_date=start_date+job.repeat.daily_interval.days
    end
  end

  def get_suffix(day)
  case day
    when "1","21","31"
      suffix = "st"
    when "2","22"
      suffix = "nd"
    when "3","23"
      suffix = "rd"
    else
      suffix = "th"
    end
  end

  def visit_select_default(job,value)
    if (job.visits.start_with? "Monthly") && (value == 'monthly')
      return 'selected'
    else
      return 
    end        
  end

  def visits_select_default(job,value)
    if (job.visits.start_with? "Weekly") && (value == 'weekly')
      return 'selected'
    else
      return 
    end  
  end

  def get_month_of_day(repeat,value)
    if !repeat.calender_day.blank?
      if repeat.calender_day.first.split(",").include? value.to_s
        return "selected"
      else
        return ""
      end
    end
  end

  def get_mothly_rule(repeat)
    if repeat.monthly_rule_type == "day_of_month"
      return true
    else
      return false          
    end
  end


  def get_mothly_rule_week(repeat)
    if repeat.monthly_rule_type == "day_of_week"
      return true
    else
      return false          
    end
  end

  def get_day_of_week(job)
    @day_weeks=[]
    if !job.repeat.calander_week.blank?
      job.repeat.calander_week.first.split(",").each do |week|    
        @day_weeks << week[0] + get_suffix(week[0]) + " " + days_full(week[2])
      end
    end
    return @day_weeks
  end
  
  def get_day_week_selected(repeat,value,instance)
    if !repeat.calander_week.blank?
      if repeat.calander_week.first.split(",").include? instance.to_s+"-"+value.to_s
        return "selected"
      else
        return ""
      end
    else
      return ""
    end 
  end

  def total_invoice_awaiting(invoices)
    @total_awaiting=0
    invoices.each do |invoice|
      invoice.invoice_works.each do |invoice_work|
        invoice_work.total.each do |amt|
          @total_awaiting=@total_awaiting+amt.to_i
        end
      end
    end
    return @total_awaiting
  end

   def add_user_information(params)
    @team_member=TeamMember.new(:user_id=>current_user.id,:full_name=>params[:full_name],:last_name=>params[:last_name],:email=>params[:email],:phone_number=>params[:phone_number],:street=>params[:street],:city=>params[:city],:state=>params[:state],:zipcode=>params[:zipcode],:ssn_number=>params[:ssn_number],:marker_color=>params[:marker_color].gsub("#",""))
    @team_member.mobile_number = params[:initial_phone]+params[:mobile_number]
    @team_member.custom_field=params[:custom_field]
    if @team_member.save
      @permission=Permission.new(:permission_show_pricing=>params[:permission][:permission_show_pricing],:permission_client_properties=>params[:permission][:permission_client_properties],:permission_quotes=>params[:permission][:permission_quotes],:permission_invoices=>params[:permission][:permission_invoices],:permission_jobs=>params[:permission][:permission_jobs],:permission_note_attachment=>params[:permission][:permission_note_attachment],:permission_reports=>params[:permission][:permission_reports], :to_dos=> params[:permission][:to_dos], :company_admin=> params[:permission][:company_admin],:team_member_id=>@team_member.id)
      @permission.save
    end  
  end

  #find job property
  def find_job_property(property_id)
    Property.find(property_id)
  end

  #find job client 
  def find_job_client(client_id)
    Client.find(client_id)
  end

  #date time format
  def date_time_format
    DateTime.now.strftime("%Y-%m-%d")
  end
  def job_date_time_format(job)
    if !job.start_date.blank?
      return  job.start_date.strftime("%Y-%m-%d")
    else
      return DateTime.now.strftime("%Y-%m-%d")
    end
  end

  #find client property for job edit
  def client_property_job(property_id)
    @property=Property.find(property_id)
  end
  #get date today
  def get_date_today
    Date.today
  end

  def job_work_tab_contain
    if current_user.user_type=="admin"
      @clients = Client.where(:user_id=>current_user.id)
      @invoices = Invoice.where(:user_id=>current_user.id )
      @quotes_draft=Quote.where(:user_id=>current_user.id ,:sent=>false)
      @quotes_sent=Quote.where(:user_id=>current_user.id,:sent=>true,:archive=>false)
      @invoices_draft = Invoice.where(:user_id=>current_user.id ,:mark_sent=>false)
      @invoices_outstand = Invoice.where(:user_id=>current_user.id ,:mark_sent=>true,:invoice_paid=>false,:invoice_bad_debt=>false,:past_due=>false)
      @invoices_past=Invoice.where(:user_id=>current_user.id,:past_due=>true)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_admin_id)
      @invoices = Invoice.where(:user_id=>user_admin_id)
      @quotes_draft=Quote.where(:user_id=>user_admin_id ,:sent=>false)
      @quotes_sent=Quote.where(:user_id=>user_admin_id,:sent=>true,:archive=>false)
      @invoices_draft = Invoice.where(:user_id=>user_admin_id ,:mark_sent=>false)
      @invoices_outstand = Invoice.where(:user_id=>user_admin_id ,:mark_sent=>true,:invoice_paid=>false,:invoice_bad_debt=>false,:past_due=>false)
      @invoices_past=Invoice.where(:user_id=>user_admin_id,:past_due=>true)
    end
  end

  #get visit name on job show
  def get_visiter_name(visit)
    return "#{visit.property.client.first_name}  #{visit.property.client.last_name}  #{visit.try(:description)}"
  end


  def fetch_client_name(params)
    if params[:property_id].blank?
      return ""
    else
      @client=Property.find(params[:property_id]).client
      return "New Job For #{@client.first_name} #{@client.last_name}"
    end
  end
  private 
  def job_new_url(params)
    if params[:client_id].blank? 
      @job = Job.new
    elsif !params[:property_id].blank?
      @job = Job.new
    else
      @client_property=Client.find(params[:client_id]).properties
      if @client_property.count == 1
        @job = Job.new
        @property_id=@client_property.first.id
      elsif @client_property.count == 0
        if params[:work]=="work"
        redirect_to new_property_path(:client_id=>params[:client_id],:job_prop=>params[:job_create],:work=>params[:work])
        elsif params[:value]=="client_show" && params[:value1]!="job_create_action"
        redirect_to new_property_path(:client_id=>params[:client_id],:value=>params[:value])
        elsif  params[:value1]=="job_create_action"
          redirect_to new_property_path(:client_id=>params[:client_id],:value1=>params[:value1])
        else
          redirect_to new_property_path(:client_id=>params[:client_id],:job_prop=>params[:job_create])
        end
      else
        if params[:work]=="work"
          redirect_to select_property_path(:client_id=>params[:client_id],:work=>params[:work])
        elsif params[:value]=="client_show"
          redirect_to select_property_path(:client_id=>params[:client_id])
        else
          if params[:date].nil?
            redirect_to select_property_path(:client_id=>params[:client_id])
          else
            redirect_to select_property_path(:client_id=>params[:client_id],:date=>params[:date])
          end       
        end
      end
    end
  end


  def property_route_count(properties,properties_add)
   return  properties.count + properties_add.count
  end


  def notification_mailer(params,job)   
    if !params[:job][:crew].blank?
       params[:job][:crew].first.split(',').each do |id| 
        user=User.find(id)
        UserMailer.job_notification(user,job).deliver
      end
    else
      user=current_user
      UserMailer.job_notification(user,job).deliver
    end
  end


  def find_company_address(general_info)
    return "#{general_info.try(:street1)}  #{general_info.try(:street2)}  #{general_info.try(:city)} #{general_info.try(:state)} #{general_info.try(:zipcode)}"
  end


  def user_plan_type_valid(user)
    if user.plan_type== "solo"
      if user.team_members.count <= 1
        return true
      else
        return false
      end
    elsif user.plan_type == "business"
      if user.team_members.count <= 5
        return true
      else
        return false
      end
    elsif user.plan_type == "team"
      if user.team_members.count <= 20
        return true
      else
        return false
      end
    end 
  end



  def default_client_property
    client = Client.create(:initial=>"Mr.",:first_name=>"copper",:last_name=>"service",:company_name=>"field service",:street1=>"24825 Northern Blvd Ste 1J",:city=>"little-neck",:state=>"NY",:zip_code=>"11362-1280",:country=>"US",:mobile_number=>"555000999",:personal_email=>"copper@mailinator.com",:user_id=>current_user.id,:demo_entry=>false)
    p1=Property.create(:street=>"24825 Northern Blvd Ste 1J",:city=>"little-neck",:state=>"NY",:zipcode=>"11362-1280",:country=>"US",:client_id=>client.id,:user_id=>current_user.id,:demo_entry=>false)
    p2=Property.create(:street=>"424 W 44th St",:city=>"New York",:state=>"NY",:zipcode=>"10036-5205",:country=>"US",:client_id=>client.id,:user_id=>current_user.id,:demo_entry=>false)
    client1 = Client.create(:initial=>"Mr.",:first_name=>"james",:last_name=>"anderson",:company_name=>"fans club",:street1=>"3511B Farrington St",:city=>"flushing",:state=>"NY",:zip_code=>"11354-2841",:country=>"US",:mobile_number=>"3332220000",:personal_email=>"james@mailinator.com",:user_id=>current_user.id,:demo_entry=>false)
    p3=Property.create(:street=>"3511B Farrington St",:city=>"flushing",:state=>"NY",:zipcode=>"11354-2841",:country=>"US",:client_id=> client1.id,:user_id=>current_user.id,:demo_entry=>false)
    p4=Property.create(:street=>"150 W 22nd Street 11th Floor",:city=>"New York",:state=>"NY",:zipcode=>"10011-9413",:country=>"US",:client_id=> client1.id,:user_id=>current_user.id,:demo_entry=>false)
    client2 = Client.create(:initial=>"Mr.",:first_name=>"jason",:last_name=>"richard",:company_name=>" yahoo",:street1=>"21337 39th Ave",:city=>"Bayside",:state=>"NY",:zip_code=>"11361-2071",:country=>"US",:mobile_number=>"5556324152",:personal_email=>"jason@mailinator.com",:user_id=>current_user.id,:demo_entry=>false)
    p5=Property.create(:street=>"21337 39th Ave",:city=>"Bayside",:state=>"NY",:zipcode=>"11361-2071",:country=>"US",:client_id=>client2.id,:user_id=>current_user.id,:demo_entry=>false)
    p6=Property.create(:street=>"3 Cushing Drive",:city=>"Bridgewater",:state=>"NJ",:zipcode=>"08807-1495",:country=>"US",:client_id=>client2.id,:user_id=>current_user.id,:demo_entry=>false)
    client3 = Client.create(:initial=>"Mr.",:first_name=>"brain",:last_name=>"smith",:company_name=>" usa club",:street1=>"17625 Union Tpke",:city=>"Fresh Meadows",:state=>"NY",:zip_code=>"11366-1515",:country=>"US",:mobile_number=>"5556324510",:personal_email=>"brain@mailinator.com",:user_id=>current_user.id,:demo_entry=>false)
    p7=Property.create(:street=>"17625 Union Tpke",:city=>"Fresh Meadows",:state=>"NY",:zipcode=>"11366-1515",:country=>"US",:client_id=>client3.id,:user_id=>current_user.id,:demo_entry=>false)
    p8=Property.create(:street=>"266 Elmwood Ave",:city=>"Buffalo",:state=>"NY",:zipcode=>"14222-2202",:country=>"US",:client_id=>client3.id,:user_id=>current_user.id,:demo_entry=>false)
    client4 = Client.create(:initial=>"Mr.",:first_name=>"john",:last_name=>"ceina",:company_name=>" wwf club",:street1=>"3763 83rd St",:city=>"Jackson Heights",:state=>"NY",:zip_code=>"11372-7146",:country=>"US",:mobile_number=>"5556663333",:personal_email=>"john@mailinator.com",:user_id=>current_user.id,:demo_entry=>false)
    p9=Property.create(:street=>"3763 83rd St",:city=>"Jackson Heights",:state=>"NY",:zipcode=>"11372-7146",:country=>"US",:client_id=>client4.id,:user_id=>current_user.id,:demo_entry=>false)
    p10=Property.create(:street=>"12 Victoria Way",:city=>"Kendall Park",:state=>"NJ",:zipcode=>"08824-1811",:country=>"US",:client_id=>client4.id,:user_id=>current_user.id,:demo_entry=>false)
    
    q1 = Quote.create(:tax=>"10",:discount=>"10",:require_deposit=>"10",:client_message=>"Demo Quotes created with content tax 10% and discount 10.",:raty_score=>"3",:user_id=>current_user.id,:quote_order=>"1",:property_id=>p1.id,:sent=>false,:archive=>false,:demo_entry=>false)  
    QuoteWork.create(:name=>["Tool"],:description=>["tool kits for all the parts."],:quantity=>["5"],:unit_cost=>["150"],:total=>["750"],:quote_id=>q1.id)
    q2 = Quote.create(:tax=>"10",:discount=>"10",:require_deposit=>"10",:client_message=>"Demo Quotes created with content tax 10% and discount 10.",:raty_score=>"3",:user_id=>current_user.id,:quote_order=>"1",:property_id=>p3.id,:sent=>true,:archive=>true,:demo_entry=>false)  
    QuoteWork.create(:name=>["Maintainace and repair"],:description=>["Repair all the machinery and all other machine changes oil."],:quantity=>["15"],:unit_cost=>["200"],:total=>["3000"],:quote_id=>q2.id)    
    q3 = Quote.create(:tax=>"10",:discount=>"10",:require_deposit=>"10",:client_message=>"Demo Quotes created with content tax 10% and discount 10.",:raty_score=>"3",:user_id=>current_user.id,:quote_order=>"1",:property_id=>p5.id,:sent=>true,:archive=>false,:demo_entry=>false)  
    QuoteWork.create(:name=>["Services"],:description=>["All type of services provide by service man."],:quantity=>["10"],:unit_cost=>["80"],:total=>["800"],:quote_id=>q3.id)
    q4 = Quote.create(:tax=>"10",:discount=>"10",:require_deposit=>"10",:client_message=>"Demo Quotes created with content tax 10% and discount 10.",:raty_score=>"3",:user_id=>current_user.id,:quote_order=>"1",:property_id=>p7.id,:sent=>false,:archive=>false,:demo_entry=>false)  
    QuoteWork.create(:name=>["Lighting"],:description=>["All type of electric fault manage."],:quantity=>["5"],:unit_cost=>["150"],:total=>["750"],:quote_id=>q4.id)
    q5 = Quote.create(:tax=>"10",:discount=>"10",:require_deposit=>"10",:client_message=>"Demo Quotes created with content tax 10% and discount 10.",:raty_score=>"3",:user_id=>current_user.id,:quote_order=>"1",:property_id=>p9.id,:sent=>false,:archive=>false,:demo_entry=>false)  
    QuoteWork.create(:name=>["Pump"],:description=>["All type of pump manage."],:quantity=>["5"],:unit_cost=>["15"],:total=>["75"],:quote_id=>q5.id)
    
    j1= Job.create(:job_order=>"1",:description=>"Its for repair TV.",:scheduled=>true,:start_date=>Date.today,:end_date=>Date.today+3.days,:visits=>"daily",:demo_entry=>false,:user_id=>current_user.id,:property_id=>p1.id)
    JobWork.create(:name=>"LG SPIN",:description=>"Its Fault occur by its wiring.",:quantity=>"1",:unit_cost=>"500",:total=>"500",:job_id=>j1.id)
    j2= Job.create(:job_order=>"2",:description=>"Its for repair FAN.",:scheduled=>true,:start_date=>Date.today,:end_date=>Date.today+4.days,:visits=>"daily",:demo_entry=>false,:user_id=>current_user.id,:property_id=>p3.id)
    JobWork.create(:name=>"BAJAJ FANS",:description=>"Its wired are demages and also barring.",:quantity=>"4",:unit_cost=>"200",:total=>"800",:job_id=>j2.id)
    j3= Job.create(:job_order=>"3",:description=>"Its for repair Machine.",:scheduled=>true,:start_date=>Date.today,:end_date=>Date.today+5.days,:visits=>"daily",:demo_entry=>false,:user_id=>current_user.id,:property_id=>p5.id)    
    JobWork.create(:name=>"Tool Machine",:description=>"Its Nuts are not tightly coupled and Other major issues",:quantity=>"3",:unit_cost=>"800",:total=>"2400",:job_id=>j3.id)
    job_visit_demo(j1)
    job_visit_demo(j2)
    job_visit_demo(j3)


    i1 =Invoice.create(:subject=>"For Services Rendered",:invoice_order=>"1",:payment=>"Upon Receipt",:issued_date=>Date.today,:tax=>"10",:discount_amount=>"10",:client_message=>"create invoices for related task.",:client_id=>client.id,:user_id=>current_user.id,:jobs_id=>["#{j1.id}"])
    InvoiceWork.create(:name=>["LG SPIN"],:description=>["Its Fault occur by its wiring."],:quantity=>["1"],:unit_cost=>["500"],:total=>["500"],:invoice_id=>i1.id)
    i2 =Invoice.create(:subject=>"For Services Rendered",:invoice_order=>"2",:payment=>"Upon Receipt",:issued_date=>Date.today,:tax=>"10",:discount_amount=>"10",:client_message=>"create invoices for related task.",:client_id=>client3.id,:user_id=>current_user.id,:mark_sent=>true)
    InvoiceWork.create(:name=>["Services"],:description=>["All type of services provide by service man."],:quantity=>["5"],:unit_cost=>["150"],:total=>["750"],:invoice_id=>i2.id)
    i3 =Invoice.create(:subject=>"For Services Rendered",:invoice_order=>"3",:payment=>"Upon Receipt",:issued_date=>Date.today,:tax=>"10",:discount_amount=>"10",:client_message=>"create invoices for related task.",:client_id=>client4.id,:user_id=>current_user.id)
    InvoiceWork.create(:name=>["Pump"],:description=>["All type of pump manage."],:quantity=>["5"],:unit_cost=>["100"],:total=>["500"],:invoice_id=>i3.id)

  end

  def job_visit_demo(job)
    start_visit = job.start_date
    end_visit = job.end_date
    while(start_visit<=end_visit)
      @visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
      @visit.title= job.description.truncate(20)
      @visit.crew=job.crew
      @visit.event_type="visit"
      @visit.save
      start_visit += 1
    end
  end
end
