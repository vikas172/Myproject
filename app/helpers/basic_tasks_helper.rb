module BasicTasksHelper
	def task_popup(p)
		if current_user.user_type == "admin"
		return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><form action='/basic_tasks/#{p.id}/complete_basic_task' method='post' class='completed_checkbox' data-remote='true' onclick='$(this).submit();'><label><input type='checkbox' name='basic_task[is_completed]' #{p.is_completed ? 'checked' : ''}> completed</label><input type='hidden' name='basic_task[complete_by]' value='#{current_user.id}'/><input type='hidden' name='basic_task[completed_date]' value='#{Date.today}'/></form><div>Starts at: <b>#{p.start_at_date}</b></div><div>Ends at: <b>#{p.end_at_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/basic_tasks/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a> or <a href='/basic_tasks/#{p.id}/edit' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>Edit</a></div></div><div class='arrow'></div></div>".html_safe
	  else
	  	if @team_member.permission.to_dos == "view_complete"
				return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><form action='/basic_tasks/#{p.id}/complete_basic_task' method='post' class='completed_checkbox' data-remote='true' onclick='$(this).submit();'><label><input type='checkbox' name='basic_task[is_completed]' #{p.is_completed ? 'checked' : ''}> completed</label><input type='hidden' name='basic_task[complete_by]' value='#{current_user.id}'/><input type='hidden' name='basic_task[completed_date]' value='#{Date.today}'/></form><div>Starts at: <b>#{p.start_at_date}</b></div><div>Ends at: <b>#{p.end_at_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/basic_tasks/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a></div></div><div class='arrow'></div></div>".html_safe
	  	else
				return "<div class='click_focus calender_details click_remove' direction='right_down' style='display: block; opacity: 1; left: 383px; top: 271px;'><div class='innerFrame click_ignore'><div class='header'><div class='title'>#{p.title}</div></div><div class='content'><form action='/basic_tasks/#{p.id}/complete_basic_task' method='post' class='completed_checkbox' data-remote='true' onclick='$(this).submit();'><label><input type='checkbox' name='basic_task[is_completed]' #{p.is_completed ? 'checked' : ''}> completed</label><input type='hidden' name='basic_task[complete_by]' value='#{current_user.id}'/><input type='hidden' name='basic_task[completed_date]' value='#{Date.today}'/></form><div>Starts at: <b>#{p.start_at_date}</b></div><div>Ends at: <b>#{p.end_at_date}</b></div><p>#{p.description.truncate(20)}</p><a href='/basic_tasks/#{p.id}/view_detail' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>View Details</a> or <a href='/basic_tasks/#{p.id}/edit' class='spin_on_click click_ignore' data-remote='true' data-toggle='modal' data-target='calender_task'>Edit</a></div></div><div class='arrow'></div></div>".html_safe
			end	
	  end
	end

	def get_team_member_task(basic_tasks)
		task_list = []
		basic_tasks.each do |basic_task|

			unless basic_task.assigned_to.blank?
				task_list << basic_task if (basic_task.assigned_to.include? current_user.id.to_s || basic_task.user_id == current_user.id) 
			end
			if (basic_task.user_id==current_user.id)
				task_list << basic_task
			end
		end
		
		return task_list.uniq
	end

	def get_assigined_user_name(user_id)
	   return  User.find(user_id).full_name 
	end

end
