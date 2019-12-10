module ShpApi
  module RescueFrom
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable
    
    included do
      
      # rescue_from are evaluated bottom-to-top so we rescue general
      # exception last.
      rescue_from Exception do |exception|
        ShpApi::JsonResponder.new(self).exception(exception: exception)
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        ShpApi::JsonResponder.new(self).param_missing(exception: exception)
      end
      
      rescue_from ActiveRecord::RecordNotFound do |exception|
        ShpApi::JsonResponder.new(self).not_found(exception: exception)
      end
      
    end
  end
end
