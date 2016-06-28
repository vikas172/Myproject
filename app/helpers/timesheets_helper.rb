module TimesheetsHelper
	def get_minutes_hours(minutes_val,hours_val)
		minutes=(minutes_val/60).to_s+":"+(minutes_val%60).to_s
		total_hours=hours_val+minutes.split(":")[0].to_i
		return (total_hours.to_s+":"+minutes.split(":")[1])
		# time_cal = Time.new(0)
		# time_cal =  time_cal+hours_val.hours+minutes_val.minutes
		# return time_cal
	end


	def get_total_hours(date,user)
		timesheets= Timesheet.where(:day=>date,:user_id=>user.id.to_s)
		@total_hour=[]
		@total_minutes=[]
		if !timesheets.blank?
			timesheets.collect(&:duration).each do |dur|
			  @total_hour << dur.strftime("%H").to_i rescue 0
			  @total_minutes << dur.strftime("%M").to_i rescue 0
			end
			@total=get_minutes_hours(@total_minutes.sum,@total_hour.sum) rescue "0:0"
		  return @total_hours12 = @total rescue "0:0"
		else
			return "0:0"
		end  
	end

	def get_week_hours(hour_total)
		@week_hour=[]
		@week_minutes=[]
		hour_total.each do |hour|
			if hour != "0:0"
				@week_hour << hour.split(":")[0].to_i rescue 0
				@week_minutes << hour.split(":")[1].to_i rescue 0
			end
		end
		@total=get_minutes_hours(@week_minutes.sum,@week_hour.sum) rescue "0:0"
		return @total
	end


	def get_user(team)
		 user = User.find(team.member_id)
		 return user
	end

		def duration_hours(hour_total)
	
			if hour_total != "0:0"
				@week_hour = hour_total.split(":")[0].to_i rescue 0
				@week_minutes = hour_total.split(":")[1].to_i rescue 0
				@week_total= @week_hour - 40
				@week_total1 = 60- @week_minutes
				return @week_total.abs.to_s+":"+@week_total1.abs.to_s
			end
   return 
	end

	def get_previous_week(user)
		if user.company.blank?
			date= (Date.today.beginning_of_week(start_day = :monday))-7
		else
			date= (Date.today.beginning_of_week(start_day = (user.company.start_week_on).to_sym))-7
		end
		return date
	end

		def get_next_week(user)
		if user.company.blank?
			date= (Date.today.beginning_of_week(start_day = :monday))+7
		else
			date= (Date.today.beginning_of_week(start_day = (user.company.start_week_on).to_sym))+7
		end
		return date
	end

	def payroll_prev_week(user,params)
		if user.company.blank?
			date= (params[:day].to_date.beginning_of_week(start_day = :monday))-7.days
		else
			date= (params[:day].to_date.beginning_of_week(start_day = (user.company.start_week_on).to_sym))-7.days
		end
		return date
	end

	def payroll_next_week(user,params)
		if user.company.blank?
			date= (params[:day].to_date.beginning_of_week(start_day = :monday))+7.days
		else
			date= (params[:day].to_date.beginning_of_week(start_day = (user.company.start_week_on).to_sym))+7.days
		end
		return date
	end


	def get_timesheet(user)
		if user.company.blank?
			start_date= (Date.today.beginning_of_week(start_day = :monday))
		else
			start_date= (Date.today.beginning_of_week(start_day = (user.company.start_week_on).to_sym))
		end
		end_date = start_date.end_of_week
		return user.timesheets.where('day BETWEEN ? AND ?',start_date,end_date )
	end

	def get_prev_timesheet(user,params)
		if user.company.blank?
			start_date= (params[:day].to_date.beginning_of_week(start_day = :monday))
		else
			start_date= (params[:day].to_date.beginning_of_week(start_day = (user.company.start_week_on).to_sym))
		end
		end_date = start_date.end_of_week
		return user.timesheets.where('day BETWEEN ? AND ?',start_date,end_date )
	end

  def duration_hour_over(hour_total)
  		if hour_total != "0:0"
				@total1=hour_total.split(":")[0].to_i*3600+hour_total.split(":")[1].to_i*60 rescue 0
				regular= "40:00"
				@regular = regular.split(":")[0].to_i*3600+regular.split(":")[1].to_i*60 rescue 0
				@total_hours= Time.at(@total1-@regular).utc.strftime("%H:%M")
				return @total_hours
			end
  end

end
