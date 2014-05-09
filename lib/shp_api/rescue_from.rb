# require 'active_record/errors'
# require "active_record/validations.rb"

module ShpApi
  module RescueFrom
    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable
    #include ActiveRecord::ActiveRecordError
    #include ActiveRecord::Validations
    #include ActiveModel::Validations
    #include ActiveModel::Model
 
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
      
      # rescue_from ActionController::RecordNotFound do |exception|
#         ShpApi::JsonResponder.new(self).not_found(exception: exception)
#       end
      
      # rescue_from Permission::AccessDenied do |exception|
#         ShpApi::JsonResponder.new(self).forbidden(exception: exception)
#       end
      
    end
  end
end
