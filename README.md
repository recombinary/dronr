# Dronr

Dronr is your Rails 4 workhorse. Boring application setup, fully automated!

Dronr is opinionated, designed to promote best practices and coding patterns, and doesn't aim to provide installations for the totality of existing things.

## Getting started

### Installation

    $ gem install dronr

### Brand new app

    $ dronr new MyApp
 
You can also supply a path to a valid register file

    $ dronr new MyApp --template templates/api_server.yml


The `dronr new` command runs like so:

1. Generate app structure (like `rails new`) with custom config (e.g. `--skip-test-unit` if RSpec was declared)
2. Install dronr gem in newly generated app & generate binstub
3. Set up register file if a template register was supplied (more on this later)
4. Invoke `dronr up` to run any new drones

### Existing app

If your app was not generated with the `dronr new` command, you can bootstrap it by navigating to the app directory and running:

    $ bundle exec dronr bootstrap

Be aware that existing apps might already have undergone manual installation of some drones you may want to add. See "Register entries for manual tasks"


# Drones

To see a list of available drones:

    $ bin/dronr list

## Adding a drone

Add a drone by appending it's name in .dronr.yml

    incoming:
      - rspec
      - simple_form
      - ...

Whenever you're ready to run new changes:

    $ bin/dronr up
    
    $ ... installing ... (feedback)



## Contributing

1. Fork it ( https://github.com/[my-github-username]/dronr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
