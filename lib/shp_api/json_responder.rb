module ShpApi
  class JsonResponder
    
    def initialize(controller)
      @controller = controller
      append_view_path_to_rails
    end
    
    ### Generic errors:
    
    # Render http 401 Unauthorized
    def unauthorized(message: "Unauthorized", meta: nil)
      @controller.render partial: "shp_api/error", locals: {
        message: message,
        error_code: "unauthorized",
        meta: meta
      }, status: 401

      return false
    end
    
    # Render http 403 Forbidden (rescue_from)
    def forbidden(exception: nil, meta: nil)
      msg = exception ? exception.message : "Forbidden"
      @controller.render partial: "shp_api/error", locals: {
        message: msg,
        error_code: "forbidden",
        meta: meta
      }, status: 403

      return false
    end
    
    # Render http 404 Not found (rescue_from)
    def not_found(exception: nil, meta: nil)
      msg = exception ? exception.message : "Not Found"
      @controller.render partial: "shp_api/error", locals: {
        message: msg,
        error_code: "not_found",
        meta: meta
      }, status: 404

      return false
    end
    
    # Render error message with custom http status
    def error(message: "Not specified", error_code: "not_specified", meta: nil)
      @controller.render partial: "shp_api/error", locals: {
        message: message,
        error_code: error_code,
        meta: meta
      }, status: 400

      return false
    end
    
    # Render generic 500 error message (rescue_from)
    def exception(exception: nil, meta: nil)
      msg = exception ? exception.message : "Internal Server Error"
      @controller.render partial: "shp_api/error", locals: {
        message: msg,
        error_code: "exception",
        meta: meta
      }, status: 500

      return false
    end
    
    ### Create/Update/Delete data:
    
    # Render http 201 Created
    def created(meta: nil)
      if meta
        @controller.render json: { meta: meta }, status: :created
      else
        @controller.head :created
      end

      return false
    end
    
    # Render http 204 No Content (update/destroy)
    def no_content
      @controller.head :no_content

      return false
    end
    
    # Render http 400 for missing parameters (rescue_from)
    def param_missing(exception: nil, meta: nil)
      msg = exception ? exception.message : "Parameter missing"
      @controller.render partial: "shp_api/error", locals: {
        message: msg,
        error_code: "param_missing",
        meta: meta
      }, status: 400

      return false
    end
    
    # Render error message including model validation errors
    def model_error(message: "Invalid", error_code: "invalid", model_errors: nil, status: 422, meta: nil)
      @controller.render partial: "shp_api/error", locals: {
        message: message,
        error_code: error_code,
        model_errors: model_errors,
        meta: meta
      }, status: status

      return false
    end
    
    # Render http 409 Conflict
    def conflict(message: "Conflict", error_code: "conflict", meta: nil)
      @controller.render partial: "shp_api/error", locals: {
        message: message,
        error_code: error_code,
        meta: meta
      }, status: 409

      return false
    end
    
    ### Other:
    
    # Render http 200 OK
    def ok(meta: nil)
      if meta
        @controller.render json: { meta: meta }, status: :ok
      else
        @controller.head :ok
      end

      return false
    end
    
    # Render http 200 OK with data
    def data(data: nil, meta: nil, status: :ok)
      if data
        result = {}
        result["status"] = "success"
        result["meta"] = meta if meta
        result["data"] = data
        json = MultiJson.dump(result)
        @controller.render json: json, status: status
      else
        @controller.head :no_content
      end
    end
    
    private
    
    def append_view_path_to_rails
      @controller.append_view_path(ShpApi.view_path)
    end
    
  end
end
