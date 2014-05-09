module ShpApi
  class JsonResponder
    
    def initialize(controller)
      @controller = controller
      append_view_path_to_rails
    end
    
    ### Generic errors:
    
    # Render http 401 Unauthorized
    def unauthorized(message: "Unauthorized")
      @controller.render partial: "shp_api/error", locals: { message: message, error_code: "unauthorized" }, status: 401
      return false
    end
    
    # Render http 403 Forbidden (rescue_from)
    def forbidden(exception: nil)
      msg = exception ? exception.message : "Forbidden"
      @controller.render partial: "shp_api/error", locals: { message: msg, error_code: "forbidden" }, status: 403
      return false
    end
    
    # Render http 404 Not found (rescue_from)
    def not_found(exception: nil)
      msg = exception ? exception.message : "Not Found"
      @controller.render partial: "shp_api/error", locals: { message: msg, error_code: "not_found" }, status: 404
      return false
    end
    
    # Render error message with custom http status
    def error(message: "Not specified", error_code: "not_specified")
      @controller.render partial: "shp_api/error", locals: { message: message, error_code: error_code }, status: 400
      return false
    end
    
    # Render generic 500 error message (rescue_from)
    def exception(exception: nil)
      msg = exception ? exception.message : "(ShpApi instance) Internal Server Error"
      @controller.render partial: "shp_api/error", locals: { message: msg, error_code: "exception" }, status: 500
      return false
    end
    
    ### Create/Update/Delete data:
    
    # Render http 201 Created
    def created
      @controller.render nothing: true, status: 201
      return false
    end
    
    # Render http 204 No Content (update/destroy)
    def no_content
      @controller.render nothing: true, status: 204
      return false
    end
    
    # Render http 400 for missing parameters (rescue_from)
    def param_missing(exception: nil)
      msg = exception ? exception.message : "Parameter missing"
      @controller.render partial: "shp_api/error", locals: { message: msg, error_code: "param_missing" }, status: 400
      return false
    end
    
    # Render error message including model validation errors
    def model_error(message: "Invalid", error_code: "invalid", model_errors: nil, status: 422)
      @controller.render partial: "shp_api/error", locals: { message: message, error_code: error_code, model_errors: model_errors }, status: status
      return false
    end
    
    # Render http 409 Conflict
    def conflict(message: "Conflict", error_code: "conflict")
      @controller.render partial: "shp_api/error", locals: { message: message, error_code: error_code }, status: 409
      return false
    end
    
    ### Other:
    
    # Render http 200 OK
    def ok
      @controller.render json: ""
      return false
    end
    
    private
    
    def append_view_path_to_rails
      @controller.append_view_path(ShpApi.view_path)
    end
    
  end
end
