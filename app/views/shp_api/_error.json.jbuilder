model_errors = [] if local_assigns[:model_errors].nil?

json.status "error"
json.data do
  json.message    message
  json.error_code error_code
  
  if model_errors.size > 0
    json.errors model_errors
  end
  
end
