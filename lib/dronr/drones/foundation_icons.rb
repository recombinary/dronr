module Dronr
  module Drones
    class FoundationIcons < Drone

      bundle do
        gem 'foundation-icons-sass-rails'
      end

      finish do
        say_status :dronr, "Now add `@import 'foundation-icons'` to your stylesheet", :red
      end

    end
  end
end
