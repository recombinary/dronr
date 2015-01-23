module Dronr

  class Drone

    attr_accessor :state
    def initialize(state=nil)
      @state = state
    end

    class DroneNotFoundError < StandardError
    end

    def self.find_class_by_human_name(human_name)
      begin
        "Dronr::Drones::#{human_name.classify}".constantize
      rescue Exception => e
        raise DroneNotFoundError.new(human_name), "`#{human_name}` is not a valid Drone name"
      end
    end

    def human_name
      self.class.to_s.demodulize.underscore
    end

    def args_for_app_create
      {}
    end

    %w{bundle install}.each do |directive|

      define_singleton_method(directive) do |&block|
        instance_variable_set :"@#{directive}_block", block
      end

      define_singleton_method("#{directive}_block") do |&block|
        instance_variable_get :"@#{directive}_block"
      end

    end

  end

end
