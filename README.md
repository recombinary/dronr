This is a long-overdue rewrite of a previous project of mine, [jeriko/app_drone](https://github.com/jeriko/app_drone)

# Dronr

Dronr is your Rails 4 workhorse. Boring application setup, fully automated!

Dronr is opinionated, designed to promote best practices and coding patterns, and doesn't aim to provide installations for the totality of existing things.

## Getting started

### Installation

    $ gem install dronr

### Create a brand new app

    $ dronr new MyApp
 
You can also supply a path to a valid register file

    $ dronr new MyApp --template templates/prototyping.yml

Or try a popular configuration (coming soon)

    $ dronr new MyApp --template https://dronr.recombinary.com/templates/api_server.yml


#### Under the hood

The `dronr new` command runs like so:

1. Generate app structure (like `rails new`) with custom config (e.g. `--skip-test-unit` if RSpec was declared)
2. Install dronr gem in newly generated app & generate binstub
3. Set up register file if a template register was supplied (more on this later)
4. Invoke `dronr up` to run any new drones

### Bootstrapping an existing app (coming soon)

If your app was not generated with the `dronr new` command, you can bootstrap it by navigating to the app directory and running:

    $ bundle exec dronr bootstrap

with an optional template argument

    $ bundle exec dronr bootstrap --template templates/prototyping.yml

This will install the dronr gem, generate a binstub, and copy the template register.

Be aware that existing apps might already have undergone manual installation of some drones you may want to add. I'll add more info here later.


# Drones

## Listing drones

Coming soon.

## Adding a drone

Register a drone for installation by adding it's name to the 'incoming' list in .dronr.yml

    incoming:
      - rspec
      - simple_form
      - ...

Whenever you're ready to run new changes:

    $ bin/dronr up

Drone work their way from `incoming`, to `bundled` (once a drone's gems have been installed), to `finished` (once a drone's installation commands have been executed).

Note that it may take multiple iterations of `dronr up` to complete the entire process. This is because gems & config are changing so code may need to be reloaded.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/dronr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
