require 'rails/generators/rails/app/app_generator'

module Dronr
  class Manager
  
    attr_accessor :app_generator, :register

    def initialize(app_generator, register=Register.new)
      @app_generator = app_generator
      @register = register
    end

    def self.from_scratch(app_name, template_register, user_params={})

      opts = { skip_bundle: true }

      template_register.drones.each do |drone|
        opts.merge! drone.args_for_app_create
      end

      generator = Rails::Generators::AppGenerator.new([app_name], opts)
      generator.invoke_all

      # BOOTSTRAP
      manager = new(generator, template_register)

      manager.say_hello

      dronr = Drones::Dronr.new(:incoming)
      manager.bundle_drone(dronr)
      manager.run_bundle
      manager.install_drone(dronr)

      manager.register.drones << dronr

      manager.commit_register

      manager.app_generator.run 'bin/dronr up'
    end


    def self.existing(options={})

      generator = Rails::Generators::AppGenerator.new [Rails.root], {}, destination_root: Rails.root

      manager = new(generator)

      manager.load_register

      canonical_register = Register.load_canonical
      manager.register.sort_by_example_register(canonical_register)

      manager.up

      manager.commit_register

      manager.say_goodbye
    end

    # def bootstrap
    # --- add dronr to register & up
    # end

    # def stage
    #   # for each drone in 'new' register
    #   # sort by canonical register
    #   # say 'staging for x drones'

    #   # output all commands..
    # end

    def commit_register
      @register.commit(register_path)
    end

    def load_register
      @register = Register.load(register_path)
    end

    def up
      incoming_drones = @register.incoming_drones.dup
      bundled_drones = @register.bundled_drones.dup

      # ----------------
      # 1. BUNDLING new drones

      incoming_drones.each do |drone|
        bundle_drone(drone)
      end

      if incoming_drones.map(&:class).detect(&:bundle_block) 
        run_bundle
      end

      # ------------
      # 2. INSTALLING bundled drones

      bundled_drones.each do |drone|
        install_drone(drone)
      end

      say_status :dronr, "Finishing..", :blue

      bundled_drones.each do |drone|
        finish_drone(drone)
      end

    end

    def bundle_drone(drone)
      say_status :dronr, "Bundling #{drone.human_name}", :blue

      if block = drone.class.bundle_block
        @app_generator.instance_eval(&block)
      end

      drone.state = :bundled
    end

    def install_drone(drone)
      say_status :dronr, "Installing #{drone.human_name}", :yellow

      if block = drone.class.install_block
        @app_generator.instance_eval(&block)
      end
    end

    def finish_drone(drone)

      if block = drone.class.finish_block
        @app_generator.instance_eval(&block)
      end

      drone.state = :finished
    end


    def say_status(*opts)
      @app_generator.say_status(*opts)
    end

    def say_hello
      say_status :dronr, 'Hello :)', :blue
    end

    def say_goodbye
      if register.finished_drones.count == register.drones.count
        say_status :dronr, 'All yours, sparky!', :blue
      else
        say_status :dronr, 'Completed iteration but some drones are unfinished. To continue working, run `bin/dronr up` in the project root.', :red
      end
    end

    def run_bundle
      @app_generator.send :bundle_command, 'install --quiet'
    end

    def app_root
      @app_generator.instance_variable_get(:@destination_stack).first
    end

    def register_path
      File.join(app_root, '.dronr.yml')
    end

  end
end
