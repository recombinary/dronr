module Dronr
  module Drones
    class Dronr < Drone

      bundle do
        gem 'dronr', "~> #{::Dronr::VERSION}"
      end

      bundle do
        gem 'dronr', path: '../../dronr'
      end if ENV['DEBUG']

      install do
        bundle_command 'binstub dronr'
      end

    end
  end
end
