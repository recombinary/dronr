module Dronr
  module Drones
    class Rspec < Drone

      def args_for_app_create
        { skip_test_unit: true }
      end

      bundle do
        gem 'rspec-rails', group: %w(development test)
      end

      install do
        generate('rspec:install')
      end

    end
  end
end
