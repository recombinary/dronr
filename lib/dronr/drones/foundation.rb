module Dronr
  module Drones
    class Foundation < Drone

      bundle do
        gem 'foundation-rails'
      end

      install do
        generate('foundation:install')
      end

    end
  end
end
