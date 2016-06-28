class LeadsController < ApplicationController
include LeadsHelper

#Display the lead
  def view_lead
    @clients = current_user.clients
  end

#Import lead modal popup open 
  def import_lead
  end

# Import file save in database  
  def import_file
  	unless params["file"].blank?
      csv_text = File.read(params["file"].tempfile)
      csv = CSV.parse(csv_text, :headers => true)
      csv.each_with_index do |row,index|
        import_property_csv(row)
      end
    end 
    redirect_to :back   
  end
  
end