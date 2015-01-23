module Dronr
  module Drones
    class Postgresql < Drone

      def args_for_app_create
        { database: 'postgresql' }
      end

      bundle do
        gem 'pg'
      end
    
    end
  end
end
