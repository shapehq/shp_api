require 'rails'
require 'jbuilder'

require "shp_api/version"
require "shp_api/rescue_from"
require "shp_api/json_responder"

module ShpApi
  
  def self.root
    File.expand_path('../..', __FILE__)
  end
  
  def self.view_path
    File.join(root, 'app', 'views')
  end
  
end
