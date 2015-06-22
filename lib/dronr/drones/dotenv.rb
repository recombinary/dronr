module Dronr
  module Drones
    class Dotenv < Drone

      bundle do
        gem 'dotenv-rails', :groups => [:development, :test]
      end

      finish do
        say_status :dronr, 'You probably want to generate a .env file'
      end

    end
  end
end
