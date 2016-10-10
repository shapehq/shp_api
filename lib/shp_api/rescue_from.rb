module ShpApi
  module RescueFrom
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable
    
    included do
      
      # rescue_from are evaluated bottom-to-top so we rescue general
      # exception last.
      rescue_from Exception do |exception|
        ShpApi::JsonResponder.new(self).exception(exception: exception)
        current_user ||= nil
        self.class.shp_api_notify_opbeat(exception: exception, user: current_user)
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        ShpApi::JsonResponder.new(self).param_missing(exception: exception)
        current_user ||= nil
        self.class.shp_api_notify_opbeat(exception: exception, user: current_user)
      end
      
      rescue_from ActiveRecord::RecordNotFound do |exception|
        ShpApi::JsonResponder.new(self).not_found(exception: exception)
        current_user ||= nil
        self.class.shp_api_notify_opbeat(exception: exception, user: current_user)
      end
      
    end
    
    module ClassMethods

      def shp_api_notify_opbeat(exception: nil, user: nil)
        class_name = 'Opbeat'
        method = 'capture_exception'
        
        # Check that class and methods exists
        return nil unless Object.const_defined?(class_name)
        c = Object.const_get(class_name)
        return nil unless c.respond_to?(method)
        
        ::Opbeat.capture_exception(
          exception,
          user: {
            id:    user.try(:id),
            email: user.try(:email)          
          }
        )
      end

    end
  
  end
end
