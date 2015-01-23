require 'spec_helper'

module Dronr

  describe Drone do

    describe '.find_class_by_human_name' do

      it 'returns the correct class when a match exists' do
        drone = Drone.find_class_by_human_name('drone1')
        expect(drone).to eq Drones::Drone1
      end

      it 'raises an error if a matching drone cant be found' do
        expect do
          Drone.find_class_by_human_name('drone90210')
        end.to raise_error(Drone::DroneNotFoundError)
      end
    end

    describe '#human_name' do

      it 'humanizes the class name' do
        expect(Drones::Drone1.new.human_name).to eq 'drone1'
        # TODO test more complex options
      end

    end

    describe 'directive DSL' do

      class TestableDrone1 < Drone
        bundle do
          'TestableDrone1 #bundle'
        end

        install do
          'TestableDrone1 #install'
        end

        finish do
          'TestableDrone1 #finish'
        end
      end

      class TestableDrone2 < Drone
        bundle do
          'TestableDrone2 #bundle'
        end

        install do
          'TestableDrone2 #install'
        end

        finish do
          'TestableDrone2 #finish'
        end
      end


      it 'captures unique #bundle and #install directives' do
        expect(TestableDrone1.bundle_block.call).to eq 'TestableDrone1 #bundle'
        expect(TestableDrone1.install_block.call).to eq 'TestableDrone1 #install'
        expect(TestableDrone1.finish_block.call).to eq 'TestableDrone1 #finish'

        expect(TestableDrone2.bundle_block.call).to eq 'TestableDrone2 #bundle'
        expect(TestableDrone2.install_block.call).to eq 'TestableDrone2 #install'
        expect(TestableDrone2.finish_block.call).to eq 'TestableDrone2 #finish'
      end

    end

  end

end
