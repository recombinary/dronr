module Dronr
  module Drones
    class Heroku < Drone

      bundle do
        gem 'rails_12factor', group: :production
      end

    end
  end
end
