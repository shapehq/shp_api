module ShpApi
  module RescueFrom
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable
    
    included do
      # rescue_from are evaluated bottom-to-top so we rescue general
      # exception last.
      rescue_from Exception do |exception|
        self.class.log_exception(exception)
        ShpApi::JsonResponder.new(self).exception(exception: exception)
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        self.class.log_exception(exception)
        ShpApi::JsonResponder.new(self).param_missing(exception: exception)
      end
      
      rescue_from ActiveRecord::RecordNotFound do |exception|
        self.class.log_exception(exception)
        ShpApi::JsonResponder.new(self).not_found(exception: exception)
      end
    end

    module ClassMethods
      def log_exception(exception)
        logger.error((["ShpApi rescued from: #{exception.class} (#{exception.message})"]+exception.backtrace).join($/))
      end
    end
  end
end
