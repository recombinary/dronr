require 'spec_helper'

module Dronr

  describe Register do

    describe '#load_canonical' do
      it 'loads the canonical register' do
        expect(Register.load_canonical).to be_a(Register)
      end
    end

    describe '#load' do

      it 'parses a YML file at the given path into a valid Register' do
        register = Register.load fixture_path('register_template.yml')

        expect(register.incoming_drones.map(&:class)).to eq([Drones::Drone2, Drones::Drone1])
        expect(register.bundled_drones.map(&:class)).to eq([Drones::Drone4])
        expect(register.finished_drones.map(&:class)).to eq([Drones::Drone3])
      end

      it 'raises an error if YML file is malformed' do
        expect do
          register = Register.load fixture_path('register_malformed.yml')
        end.to raise_error(Register::MalformedRegisterError)
      end

      it 'raises an error if YML file is missing keys' do
        expect do
          register = Register.load fixture_path('register_keys_missing.yml')
        end.to raise_error(Register::MalformedRegisterError)
      end

      it 'raises an error if a named drone couldnt be found' do
        expect do
          register = Register.load fixture_path('register_drone_not_found.yml')
        end.to raise_error(Drone::DroneNotFoundError)
      end

      it 'raises an error if the register is invalid' do
        expect do
          register = Register.load fixture_path('register_invalid.yml')
        end.to raise_error(Register::InvalidRegisterError)
      end

    end

    describe '#sort_by_example_register' do

      it 'returns drones ordered correctly' do

        canonical_register = Register.new([
          Drones::Drone1.new(:incoming),
          Drones::Drone2.new(:incoming),
          Drones::Drone3.new(:incoming),
          Drones::Drone4.new(:incoming)
        ])

        drone4 = Drones::Drone4.new(:bundled)
        drone1 = Drones::Drone1.new(:incoming)
        drone3 = Drones::Drone3.new(:finished)

        register = Register.new([drone4, drone1, drone3])

        register.sort_by_example_register(canonical_register)
        expect(register.drones).to eq [drone1, drone3, drone4]
      end

    end


    describe '#valid?' do

      it 'returns true when all entries are unique subclasses of Drone' do
        register = Register.new([
          Drones::Drone1.new(:incoming),
          Drones::Drone2.new(:bundled),
          Drones::Drone3.new(:finished)
        ])
        expect(register).to be_valid
      end

      it 'returns false if there are duplicate drones of the same kind' do
        register = Register.new([
          Drones::Drone1.new(:incoming),
          Drones::Drone1.new(:incoming)
        ])
        expect(register).to_not be_valid
      end

      it 'returns false if a particular drone appears in both arrays' do
        register = Register.new([
          Drones::Drone1.new(:incoming), 
          Drones::Drone1.new(:bundled),
          Drones::Drone2.new(:bundled)
        ])
        expect(register).to_not be_valid
      end

      it 'returns false unless all entries are subclasses of Drone' do
        register = Register.new([
          Drones::Drone1.new(:incoming),
          nil
        ])
        expect(register).to_not be_valid
      end
    end

    describe '#to_yml' do

      it 'correctly generates a YML file' do
        register = Register.new([
          Drones::Drone1.new(:incoming),
          Drones::Drone2.new(:finished),
          Drones::Drone3.new(:finished)
        ])

        yaml = YAML.load(register.to_yaml)

        expect(yaml['incoming']).to eq %w{drone1}
        expect(yaml['bundled']).to eq nil
        expect(yaml['finished']).to eq %w{drone2 drone3}
      end

    end

    describe '#commit' do

      it 'serializes to yaml and saves at the given path' do

        register = Register.new([
          Drones::Drone1.new(:incoming),
          Drones::Drone2.new(:bundled),
          Drones::Drone3.new(:finished)
        ])

        path = File.expand_path '../../tmp/dronr.yml', __FILE__

        File.delete(path) if File.exists?(path)
        expect(File.exists?(path)).to eq false

        register.commit(path)

        expect(File.exists?(path)).to eq true
        expect(Register.load(path)).to be_valid
      end
    end

  end

end
