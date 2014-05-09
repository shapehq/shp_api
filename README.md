# ShpApi

Shape API gem for Rails apps containing the most common methdos shared by
all our API's.

## Installation

Add this line to your application's Gemfile:

    gem 'shp_api', '~> 0.0.1', github: 'shapehq/shape_api_standards_public'

And then execute:

    $ bundle install

## Usage

A projects common Api controller should:

```ruby
include ShpApi::RescueFrom
```
which then returns common JSON error responses for the following exceptions:

* Exception
* ActionController::ParameterMissing
* ActiveRecord::RecordNotFound





## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
