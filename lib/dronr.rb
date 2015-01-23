require 'dronr/version'
require 'pry'

require 'rails'
require 'rails/generators'

module Dronr

  extend ActiveSupport::Autoload

  autoload :CLI
  autoload :Drone
  autoload :Drones
  autoload :Manager
  autoload :Register

end
