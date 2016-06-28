module DocumentsHelper

	def dependency_all(user)
		@team_members=user.team_members
		if !@team_members.blank?
			@team_members.each do |member|
				@user=User.find(member.member_id)
				@user.destroy
			end
		end
		user.team_members.delete_all if !user.team_members.blank?
		if !user.clients.blank?
			user.clients.each do |client|
				if !client.notes.blank?
					client.notes.each do |note|
						note.attachments.delete_all if !note.attachments.blank?
					end
				end
				client.emails.delete_all if !client.emails.blank?
				client.phones.delete_all if !client.phones.blank?
				client.tags.delete_all if !client.tags.blank?
			end
			user.clients.delete_all 
		end
		if !user.jobs.blank?
			user.jobs.each do |job|
				job.job_works.delete_all
				job.visit_schedules.delete_all
				if job.notes.blank?
					job.notes.each do |note|
						note.attachments.delete_all if !note.attachments.blank?
					end
				end	
			end	
			user.jobs.delete_all 
		end
		if !user.quotes.blank?
			user.quotes.each do |quote|
			  quote.quote_works.delete_all
			  if quote.notes.blank?
					quote.notes.each do |note|
						note.attachments.delete_all if !note.attachments.blank?
					end
				end	
			end
			user.quotes.delete_all 
		end
		if !user.invoices.blank?
			user.invoices.each do |invoice|
				invoice.invoice_works.delete_all
				if invoice.notes.blank?
					invoice.notes.each do |note|
						note.attachments.delete_all if !note.attachments.blank?
					end
				end	
			end
			user.invoices.delete_all 
		end
		user.pdf_setting.delete if !user.pdf_setting.blank?
		user.payment_invoices.delete_all if !user.payment_invoices.blank?
		user.service_products.delete_all if !user.service_products.blank? 
	end
end
