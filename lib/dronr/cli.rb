require 'thor'
require 'thor/rails'

module Dronr
  class CLI < Thor

    include Thor::Rails

    def new
    #   # generate application
    #   # -- skip test suite, skip bundle
    #   # -- database postgres
    #   # -- add dronr gem, group: :development
    #   # -- bundle
    end

    desc 'add', 'Adds a feature'

    def add(feature_name)
      if defined?(feature_name)
        puts "feature was added"
      else
        puts "feature not found: #{feature_name}"
      end
    end

  end
end
