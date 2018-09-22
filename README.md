# Tankerkoenig

This is a Ruby Wrapper for the [Tankerkönig HTTP API](https://creativecommons.tankerkoenig.de).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tankerkoenig'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tankerkoenig

## Usage

Set the API Token

```ruby
Tankerkoenig.api_key = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

Get the detail of a single station

```ruby
Tankerkoenig::Station.detail('24a381e3-0d72-416d-bfd8-b2f65f6e5802')
# => #<Tankerkoenig::Response @ok=true @result=#<Tankerkoenig::Station [...]> [...]>
```

Search stations in the radius of the given coordinates.

```ruby
Tankerkoenig::Station.list(52.521, 13.438, 1.5, 'all', 'dist')
# => #<Tankerkoenig::Response @ok=true @result=[#<Tankerkoenig::Station [...]>, #<Tankerkoenig::Station [...]>] [...]>
```

Get the prices of a list of stations

```ruby
Tankerkoenig::Price.get(['4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8', '446bdcf5-9f75-47fc-9cfa-2c3d6fda1c3b', '60c0eefa-d2a8-4f5c-82cc-b5244ecae955', '44444444-4444-4444-4444-444444444444'])
# or
Tankerkoenig::Price.get('4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8,446bdcf5-9f75-47fc-9cfa-2c3d6fda1c3b,60c0eefa-d2a8-4f5c-82cc-b5244ecae955,44444444-4444-4444-4444-444444444444')

# => #<Tankerkoenig::Response @ok=true @result=[#<Tankerkoenig::Price [...]>, #<Tankerkoenig::Price [...]>] [...]>
```

Interacting with the `Tankerkoenig::Station` class.

```ruby
stations = Tankerkoenig::Station.list(52.521, 13.438, 1.5, 'all', 'dist').result
station = stations.first

station.brand
# => "TOTAL"

station.street
# => "MARGARETE-SOMMER-STR"

station.place
# => "BERLIN"

station.e5?
# => true

station.e5
# => 1.499

station.e10?
# => true

station.e10
# => 1.479

station.diesel?
# => true

station.diesel
# => 1.309

station.open?
# => true

station.whole_day?
# => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/tankerkoenig-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
