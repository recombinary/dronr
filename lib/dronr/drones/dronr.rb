module Dronr
  module Drones
    class Dronr < Drone

      bundle do
        gem 'dronr', "~> #{::Dronr::VERSION}", group: :development
      end

      bundle do
        gem 'dronr', path: '../../dronr', group: :development
      end if ENV['DEBUG']

      install do
        bundle_command 'binstub dronr'
      end

    end
  end
end
