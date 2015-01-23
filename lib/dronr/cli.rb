require 'thor'

module Dronr
  class CLI < Thor

    # TODO you need a better way to detect if dronr is being run within a Rails app.
    # Maybe don't detect, just load Thor::Rails for the specific methods that require it?
    # esp. since it's currently impossible to run full path commands e.g. `~/Code/appname/bin/dronr up`
    IS_RAILS_APP = File.exists? File.join(Dir.getwd, 'config/environment.rb')

    if IS_RAILS_APP
      require 'thor/rails'
      include Thor::Rails
    end

    desc 'new', 'Generates a new Rails app, with dronr installed'
    option :template

    def new(app_name)
      app_requirement(false)

      # TODO allow CLI params thru
      #   # args = Rails::Generators::ARGVScrubber.new([]).prepare!
      #   args = [app_name]

      template_register = if template_path = options[:template]
        Register.load(template_path)
      else
        Register.new
      end

      Dronr::Manager.from_scratch(app_name, template_register)
    end


    # desc 'stage', 'Generates a new Rails app, with dronr installed'
    # def stage
    #   load_app
    #   app_requirement(true)

    #   app_generator = Rails::Generators::AppGenerator.new [Rails.root], {}, destination_root: Rails.root
    #   manager = Dronr::Manager.new(app_generator)
    #   manager.stage  
    # end

    desc 'up', 'Installs all pending drones based on dronr.yml'
    option :loop

    def up
      app_requirement(true)

      Dronr::Manager.existing({ loop: options[:loop] })

    end

    # def yank
    #   app_requirement(true)
    #   # CONFIRM ARE YOU SURE?

    #   # self destruct, yank self completely
    # end



  protected

    def app_requirement(required)
      if IS_RAILS_APP
        raise "FATAL: Existing app detected: #{::Rails.application}" if !required
      else
        raise "FATAL: App not found" if required
      end
    end

  end
end
