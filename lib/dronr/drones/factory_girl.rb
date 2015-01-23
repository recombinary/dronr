module Dronr
  module Drones
    class FactoryGirl < Drone

      bundle do
        gem 'factory_girl_rails', group: %w(development test)
      end

    end
  end
end
