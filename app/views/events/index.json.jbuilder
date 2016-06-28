json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :start_time, :end_time,:start_date,:end_date
  json.start event.start_date
  json.path event_url(event)
  # json.url event_url(event, format: :html)
end
json.array!(@jobs) do |job|
  json.extract! job, :id, :description, :scheduled, :start_time, :end_time,:start_date,:end_date
  json.title 'job'
  json.start job.start_date
  json.path job_url(job)
  # json.url job_url(job, format: :html)
end

