class Vendor < ActiveRecord::Base
  belongs_to :user


geocoded_by :street   # can also be an IP address
after_validation :geocode          # auto-fetch coordinates
def self.import(file)
	
  spreadsheet = Roo::Spreadsheet.open(file.path,:extension=>"xlsx")
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
  	
    row = Hash[[header, spreadsheet.row(i)].transpose]
    vendor = find_by_id(row["id"]) || new
    vendor.vendor_type = row["Type"]
    vendor.name = row["Name"]
    vendor.location_name = row["LOCATION_NAME"]
    vendor.street = row["ADDRESS"]
    vendor.city = row["CITY"]
    vendor.state = row["STATE"]
    vendor.zipcode = row["ZIP"]
    vendor.phone = row["PHONE"]
    vendor.source = row["Source"]
    vendor.fax = row["FAX"]
    vendor.save!
  end
end

end


