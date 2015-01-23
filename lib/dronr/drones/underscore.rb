module Dronr
  module Drones
    class Underscore < Drone

      bundle do
        gem 'underscore-rails'
      end

      finish do
        say_status :dronr, 'Now add `//= require underscore` to your javascript manifest'
      end

    end
  end
end
