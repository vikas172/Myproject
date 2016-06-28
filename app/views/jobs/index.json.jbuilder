json.array!(@jobs) do |job|
  json.extract! job, :id, :description, :scheduled, :start_date, :end_date, :visits, :start_time, :end_time, :crew, :invoicing, :invoice_period, :first_invoice_on
  json.url job_url(job, format: :json)
end
