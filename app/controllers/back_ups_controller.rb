class BackUpsController < ApplicationController
    require 'csv'

    def back_check
    end

#Generate invoice csv file
    def property_csv(params)
        @properties= Property.where(:user_id=>current_user.id.to_s)
        csv_string = CSV.generate do |csv|
            csv << ["street","street2","city","state","zipcode","country","client_id","user_id"]
            @properties.each do |property|  
                csv << [property.try(:street), property.try(:street2),property.try(:city),property.try(:state),property.try(:zipcode),property.try(:country),property.try(:client_id),property.try(:user_id)]
            end
        end
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=properties.csv"
    end

#Generate client csv file
    def client_csv(params)
        @clients = Client.where(:user_id=>current_user.id.to_s)     
            csv_string = CSV.generate do |csv|
                csv << ["initial","first_name","last_name","company_name","street1","street2","city","state","zip_code","country","user_id","custom_field","mobile_number","personal_email"]
                @clients.each do |client|  
                    csv << [client.try(:initial), client.first_name, client.last_name, client.company_name, client.try(:street1), client.try(:street2), client.try(:city), client.try(:state), client.try(:zip_code) ,client.try(:country),client.try(:user_id),client.try(:custom_field),client.try(:mobile_number),client.try(:personal_email) ]
                end
            end
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=clients.csv"
    end

#Generate invoice csv file
    def invoice_csv(params)
        @invoices = Invoice.where(:user_id=>current_user.id.to_s)
        csv_string = CSV.generate do |csv|
            csv << ["payment","subject","issued_date","due_date","tax","discount_amount","discount_type","deposite_amount","entry_date","payment_method_type","payment_method","additional_note","client_message","invoice_order"]
            @invoices.each do |invoice|  
                csv << [invoice.try(:payment),invoice.try(:subject),invoice.try(:issued_date),invoice.try(:due_date),invoice.try(:tax),invoice.try(:discount_amount),invoice.try(:discount_type),invoice.try(:deposite_amount),invoice.try(:entry_date),invoice.try(:payment_method_type),invoice.try(:payment_method),invoice.try(:additional_note),invoice.try(:client_message),invoice.try(:invoice_order)]
            end
        end
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=invoices.csv"  
    end

#Generate item csv file
    def item_csv(params)
        @items = Item.where(:user_id=>current_user.id.to_s)
        csv_string = CSV.generate do |csv|
            csv << ["name","description","product_model_number","vendor_part_number","vendor_name","quantity","unit_value","value","vendor_url","category","location","image_file_name","image_content_type","image_file_size","image_updated_at","user_id","l_name","l_description","l_product_model","l_vendor_part","l_vendor_name","l_quantity","l_unit","l_value","l_vendor_url","l_category","l_location","l_image"]
            @items.each do |item|  
                csv << [item.try(:name),item.try(:description),item.try(:product_model_number),item.try(:vendor_part_number),item.try(:vendor_name),item.try(:quantity),item.try(:unit_value),item.try(:value),item.try(:vendor_url),item.try(:category),item.try(:location),item.try(:image_file_name),item.try(:image_content_type),item.try(:image_file_size),item.try(:image_updated_at),item.try(:user_id),item.try(:l_name),item.try(:l_description),item.try(:l_product_model),item.try(:l_vendor_part),item.try(:l_vendor_name),item.try(:l_quantity),item.try(:l_unit),item.try(:l_value),item.try(:l_vendor_url),item.try(:l_category),item.try(:l_location),item.try(:l_image)]
            end
        end
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=items.csv"  
    end

#Generate job csv file
    def job_csv(params)
        @jobs = Job.where(:user_id=>current_user.id.to_s)
        csv_string = CSV.generate do |csv|
            csv << ["description","scheduled","start_date","end_date","visits","start_time","end_time","crew","invoicing","invoice_period","first_invoice_on","property_id","job_type","number_of_invoice","invoice_type","user_id","job_status","job_required","job_complete","complete_on","quote_id","custom_field","job_order"]
            @jobs.each do |job|  
                csv << [job.try(:description),job.try(:scheduled),job.try(:start_date),job.try(:end_date),job.try(:visits),job.try(:start_time),job.try(:end_time),job.try(:crew),job.try(:invoicing),job.try(:invoice_period),job.try(:first_invoice_on),job.try(:property_id),job.try(:job_type),job.try(:number_of_invoice),job.try(:invoice_type),job.try(:user_id),job.try(:job_status),job.try(:job_required),job.try(:job_complete),job.try(:complete_on),job.try(:quote_id),job.try(:custom_field),job.try(:job_order)]
            end
        end
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=jobs.csv"  
    end

# Display backup import and export
    def manage_data
    end

# Import csv file clients, jobs and items
    def csv_upload
        @attachment= Attachment.new
    end

#Import file store in database
    def csv_import
        if params[:csv_file] == "clients"
            Client.import(params[:attachment][:image])
        elsif params[:csv_file] == "jobs"
            Job.import(params[:attachment][:image])
        elsif params[:csv_file] == "items"
            Item.import(params[:attachment][:image])
        end    
        redirect_to manage_data_path
    end

#Download templates for clients , jobs and items
    def download_template
        if params[:temp] == "clients"
            send_file(
            "#{Rails.root}/public/templates_csv/ExampleClients.csv",
            filename: "ExampleClients.csv",
            type: "text/csv"
            )
        elsif params[:temp] == "jobs"
            send_file(
            "#{Rails.root}/public/templates_csv/ExampleJobs.csv",
            filename: "ExampleJobs.csv",
            type: "text/csv"
            )    
        elsif params[:temp] == "items"
            send_file(
            "#{Rails.root}/public/templates_csv/ExampleItems.csv",
            filename: "ExampleItems.csv",
            type: "text/csv"
            )
        end
    end

# Export csv file for clients , properties , invoices , jobs and items
    def csv_generate
        require 'csv'
        if !params[:csv_file].blank?
            if params[:csv_file] == "clients"
                client_csv(params)
            elsif params[:csv_file] == "properties"
                property_csv(params)
            elsif params[:csv_file] == "invoices"
                invoice_csv(params)
            elsif params[:csv_file] == "jobs"
                job_csv(params)
            elsif params[:csv_file] == "items"
                item_csv(params)
            else
                redirect_to :back
            end
        else
            redirect_to :back
        end
    end
end