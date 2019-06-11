model_errors = [] if local_assigns[:model_errors].nil?

json.status "error"
json.meta meta if meta
if error_data
  json.data error_data if error_data
else
  json.data do
    json.message message
    json.error_code error_code
    if json.data
      json.data data
    end
    if model_errors.size > 0
      json.errors model_errors
    end
  end
end

