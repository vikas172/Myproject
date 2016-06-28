module ChamicalsHelper

	def get_client_name(chamical)
		chamical.property.client.initial+" "+chamical.property.client.first_name+" "+chamical.property.client.last_name
	end

	def client_address(chamical)
		chamical.property.street+" / "+chamical.property.street2+" / "+chamical.property.city+" / "+chamical.property.state+" "+chamical.property.zipcode
	end

	def get_job_work_by_job(jobs)
		job_work_arr = []
		job_work_arr << ["Don't attach to Job", ""]
		unless jobs.blank?
			jobs.each do |job|
				@job_work = job.job_work_total(job.id)
				job_work_arr << ["##{job.job_order} / #{job.start_date.strftime("%m/%d/%Y")} / ##{@job_work.pluck(:total).sum}", "#{job.id}"]
			end
		end
		return job_work_arr
	end

	def get_applicator_name
		team_member_arr = []
		team_member_arr << ["Set Later", ""]
		team_member_arr << ["#{current_user.full_name}", current_user.id]
		@team_members = current_user.team_members
		@team_members.each do |team_member|
			team_member_arr << ["#{team_member.full_name}", team_member.member_id]
		end
		return team_member_arr
	end

	def get_chemicals_mixture_name(chemicals_setting)
		chemicals_name = []
		unless chemicals_setting.blank?
			unless chemicals_setting.chemicals.blank?
				chemicals_setting.chemicals.keys.each do |chemical|
					chemicals_name << chemicals_setting.chemicals[chemical]["name"]
				end
			end
		end
		return chemicals_name
	end

	def get_chemical_and_mixture(chemicals_setting, chemical_mixtures)
		main_select = []
		chemicals_name = []
		mixtures_name = []
		main_select << ["",["Set Later"]]
		chemicals_name << "chemicals"
		unless chemicals_setting.blank?
			unless chemicals_setting.chemicals.blank?
				chemicals_setting.chemicals.keys.each do |chemical|
					chemicals_name << [chemicals_setting.chemicals[chemical]["name"]]
				end
			else
				chemicals_name << []
			end
		else
			chemicals_name << []
		end
		mixtures_name << "Mixtures"
		unless chemical_mixtures.blank?
			mixtures_name << chemical_mixtures.pluck(:name)
		end
		mixtures_name << [] if chemical_mixtures.blank?
		main_select << chemicals_name
		main_select << mixtures_name
		return main_select 
	end
end
