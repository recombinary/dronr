require 'yaml'

module Dronr

  class Register

    CANONICAL_PATH = '..'

    class MalformedRegisterError < StandardError
    end

    class InvalidRegisterError < StandardError
    end

    %W{incoming bundled finished}.each do |state|
      define_method "#{state}_drones" do
        drones.select do |drone|
          drone.state == state.to_sym
        end
      end
    end

    attr_reader :drones

    def initialize(drones=[])
      @drones = drones
    end

    def self.load_canonical
      canonical_path = File.expand_path '../register/canonical.yml', __FILE__
      load(canonical_path)
    end

    def self.load(path)
      begin
        yaml = YAML.load_file(path)
      rescue Psych::SyntaxError
        raise MalformedRegisterError.new(yaml), 'is not valid YAML'
      end

      unless yaml.has_key?('incoming') && yaml.has_key?('bundled') && yaml.has_key?('finished')
        raise MalformedRegisterError.new(yaml), 'is missing required keys (incoming, bundled, finished)'
      end

      drones = %w{incoming bundled finished}.map do |state|
        (yaml[state] || []).map do |drone_name|
          klass = Drone.find_class_by_human_name(drone_name)
          klass.new(state.to_sym)
        end
      end.flatten

      new(drones).tap do |register|
        unless register.valid?
          raise InvalidRegisterError.new(register), "Couldnt load register at #{path}"
        end
      end
    end

    def valid?
      has_valid_drones = drones.all? do |drone|
        drone && (drone.class < Drone)
      end

      has_no_duplicate_drones = (drones.count == drones.map(&:class).uniq.count)

      has_valid_drones && has_no_duplicate_drones
    end

    def sort_by_example_register(example_register)
      @drones = example_register.drones.map do |drone|
        @drones.detect{ |d| d.class == drone.class }
      end.compact
    end

    def to_yaml
      {
        'incoming' => incoming_drones.map(&:human_name).presence,
        'bundled' => bundled_drones.map(&:human_name).presence,
        'finished' => finished_drones.map(&:human_name).presence
      }.to_yaml
    end

    def commit(path)
      File.open(path, 'w+') do |f|
        f.write(to_yaml)
      end
    end

  end

end
