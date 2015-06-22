module Dronr
  module Drones
    class Compass < Drone

      bundle do
        gem 'compass-rails'
      end

      finish do
        say_status :dronr, "Now add `@import 'compass'` to your stylesheet", :red
      end

    end
  end
end
