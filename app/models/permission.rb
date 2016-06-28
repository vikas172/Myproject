class Permission < ActiveRecord::Base
	belongs_to :team_member
	belongs_to :user
	serialize :permission_client_properties
	serialize :permission_quotes
	serialize :permission_invoices
	serialize :permission_note_attachment
	serialize :permission_jobs
end
