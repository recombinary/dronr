module Dronr
  module Drones
    class Cleanup < Drone

      install do
        rake 'db:create'
      end

    end
  end
end
