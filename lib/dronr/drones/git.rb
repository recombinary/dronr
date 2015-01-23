module Dronr
  module Drones
    class Git < Drone

      install do
        git :init
      end

    end
  end
end
