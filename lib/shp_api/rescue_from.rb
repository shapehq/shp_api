# require 'active_record/errors'
# require "active_record/validations.rb"

module ShpApi
  module RescueFrom
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable
    
    included do
      
      # rescue_from are evaluated bottom-to-top so we rescue general
      # exception last.
      rescue_from Exception do |exception|
        ShpApi::JsonResponder.new(self).exception(exception: exception)
        self.class.shp_api_notify_opbeat(exception: exception)
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        ShpApi::JsonResponder.new(self).param_missing(exception: exception)
        self.class.shp_api_notify_opbeat(exception: exception)
      end
      
      rescue_from ActiveRecord::RecordNotFound do |exception|
        ShpApi::JsonResponder.new(self).not_found(exception: exception)
        self.class.shp_api_notify_opbeat(exception: exception)
      end
      
    end
    
    module ClassMethods

      def shp_api_notify_opbeat(exception: nil)
        self.class.shp_api_class_send('::Opbeat', 'capture_exception', exception)
      end

      # Only call Opbeat if class and method exists
      def shp_api_class_send(class_name, method, *args)
        return nil unless Object.const_defined?(class_name)
        c = Object.const_get(class_name)
        c.respond_to?(method) ? c.send(method, *args) : nil
      end

    end
  
  end
end
