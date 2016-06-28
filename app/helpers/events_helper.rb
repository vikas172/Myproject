module EventsHelper

	def basic_popup(p)
		if current_user.user_type == "admin"
		return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><div>Starts at: <b>#{p.start_date}</b></div><div>Ends at: <b>#{p.end_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/events/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a> or <a href='/events/#{p.id}/edit' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>Edit</a></div></div><div class='arrow'></div></div>".html_safe
	  else
	  	# if @team_member.permission.to_dos == "view_complete"
				return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><div>Starts at: <b>#{p.start_date}</b></div><div>Ends at: <b>#{p.end_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/events/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a></div></div><div class='arrow'></div></div>".html_safe	
	  	# else
				# return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><div>Starts at: <b>#{p.start_date}</b></div><div>Ends at: <b>#{p.end_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/events/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a> or <a href='/events/#{p.id}/edit' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>Edit</a></div></div><div class='arrow'></div></div>".html_safe
	  	# end
	  end
	end

	def get_job_for_calender
		@job_events = []
		job_list = []
		if current_user.user_type == "admin"
			@jobs = current_user.jobs
		else
		Job.all.each do |job|
			unless job.crew.blank?
				job_list << job if (job.crew.include? current_user.id.to_s || job.user_id == current_user.id) 
			end
		end
			@jobs = job_list
		end
		@jobs.each do |p|
			unless p.start_date.blank? || p.end_date.blank?
				job_start = p.start_date
				job_end = p.end_date
				if p.visits == "daily"

					while(job_start<=job_end)
						@job_events << {:start => (job_start.strftime("%Y-%m-%d") if !p.start_date.blank?)}
						job_start = job_start+1
					end
				elsif p.visits == "weekly"
					while(job_start<=job_end)
						@job_events << {:start => (job_start.strftime("%Y-%m-%d") if !p.start_date.blank?)}
						job_start = job_start+7
					end
				elsif p.visits == "monthly"
					while(job_start<=job_end)
						@job_events << {:start => (job_start.strftime("%Y-%m-%d") if !p.start_date.blank?)}
						job_start = job_start+30
					end
				else
					while(job_start<=job_end)
						@job_events << {:start => (job_start.strftime("%Y-%m-%d") if !p.start_date.blank?)}
						job_start = job_start+1
					end
				end
			end
		end
		return @job_events.group_by{|d| d[:start] }
	end

	def visit_popup(p)
		return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><form action='/events/visit_complete_event/#{p.id}' method='post' class='completed_checkbox' data-remote='true' onclick='$(this).submit();'><label><input type='checkbox' name='job_type' #{p.job_complete ? 'checked' : ''}> completed</label><input type='hidden' name='complete_by' value='#{current_user.full_name}'/><input type='hidden' name='visit_schedule_id' value='#{p.id}'/></form><div>Starts at: <b>#{p.start_date}</b></div><div>Ends at: <b>#{p.end_date}</b></div><p>asdfsadfasdfasd</p><a href='events/visit_view_detail_event/#{p.id}' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='#assigned_visit_modal'>View Details</a> or <a href='events/edit_visit_event/#{p.id}' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='#edit_visit_plan_modal'>Edit</a></div></div><div class='arrow'></div></div>".html_safe
	end
	def visit_popup_day(p)
		return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p[:title]}</div></div><div class='content'><form action='/events/visit_complete_event/#{p[:id]}' method='post' class='completed_checkbox' data-remote='true' onclick='$(this).submit();'><label><input type='checkbox' name='job_type' #{p[:job_complete] ? 'checked' : ''}> completed</label><input type='hidden' name='complete_by' value='#{current_user.full_name}'/><input type='hidden' name='visit_schedule_id' value='#{p[:id]}'/></form><div>Starts at: <b>#{p[:start_date]}</b></div><div>Ends at: <b>#{p[:end_date]}</b></div><p>asdfsadfasdfasd</p><a href='events/visit_view_detail_event/#{p[:id]}' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='#assigned_visit_modal'>View Details</a> or <a href='events/edit_visit_event/#{p[:id]}' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='#edit_visit_plan_modal'>Edit</a></div></div><div class='arrow'></div></div>".html_safe

	end

	def assigned_user_detail(crew,user)
		crew.each do |user_id|
			user << User.find(user_id)
		end
	end
end