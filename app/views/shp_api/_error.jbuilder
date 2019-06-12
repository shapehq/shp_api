model_errors = [] if local_assigns[:model_errors].nil?
error_data = nil if local_assigns[:error_data].nil?
json.status "error"
json.meta meta if meta
if error_data
  json.data error_data
else
  json.data do
    json.message message
    json.error_code error_code
    if model_errors.size > 0
      json.errors model_errors
    end
  end
end

