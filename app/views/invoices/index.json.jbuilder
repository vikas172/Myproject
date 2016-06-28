json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :payment, :subject, :issued_date, :tax, :discount_amount, :discount_type, :deposite_amount, :entry_date, :payment_method_type, :payment_method, :additional_note, :client_message
  json.url invoice_url(invoice, format: :json)
end
