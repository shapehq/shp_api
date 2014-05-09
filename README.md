# ShpApi

Shape API gem for Rails apps containing the most common methods shared by
all our API's.

## Installation

Add this line to your application's Gemfile:

    gem 'shp_api', '~> 0.0.1', github: 'shapehq/shp_api'

And then execute:

    $ bundle install

## Usage

The gem currently consists of two parts:

* Common resque_from blocks for API controllers.
* Common responses for API JSON views.


### Common resque_from blocks

The base API controller should:

```ruby
include ShpApi::RescueFrom
```
which will then return common JSON error responses for the following exceptions:

* Exception
* ActionController::ParameterMissing
* ActiveRecord::RecordNotFound


### Common JSON responses

Any API controller can use the following methods to return a standard JSON response.

#### Generic/Shared

##### User not signed in

```ruby
ShpApi::JsonResponder.new(self).unauthorized(message: "Unauthorized")
```

Returns status: 401 Unauthorized

```JSON
{
  "status": "error",
  "data": {
    "message": "Unauthorized",
    "error_code": "unauthorized"
  }
}
```

##### Insufficient user rights

```ruby
ShpApi::JsonResponder.new(self).forbidden
```

Returns status: 403 Forbidden

```JSON
{
  "status": "error",
  "data": {
    "message": "User doesn't have rights to create employees",
    "error_code": "forbidden"
  }
}
```

##### Not Found

```ruby
ShpApi::JsonResponder.new(self).not_found(exception: nil)
```

Returns status: 404 Not Found

```JSON
{
  "status": "error",
  "data": {
    "message": "Not Found",
    "error_code": "not_found"
  }
}
```

##### Bad Request/Error with custom error_code

```ruby
ShpApi::JsonResponder.new(self).error(message: "Not specified", error_code: "not_specified")
```

Returns status: 400 Bad Request

```JSON
{
  "status": "error",
  "data": {
    "message": "Not specified",
    "error_code": "not_specified"
  }
}
```

##### Internal Server Error

```ruby
ShpApi::JsonResponder.new(self).exception
```

Returns status: 500 Internal Server Error

```JSON
{
  "status": "error",
  "data": {
    "message": "Internal Server Error",
    "error_code": "exception"
  }
}
```

#### Create/Update/Delete data

##### Create single object

```ruby
ShpApi::JsonResponder.new(self).created
```

Returns status: 201 Created with an empty body

##### Update/Delete single object

```ruby
ShpApi::JsonResponder.new(self).no_content
```

Returns status: 204 No Content with an empty body

##### Required parameters missing

```ruby
ShpApi::JsonResponder.new(self).param_missing(exception: nil)
```

Returns status: 400 Bad Request

```JSON
{
  "status": "error",
  "data": {
    "message": "Param not found: employee_title",
    "error_code": "param_missing"
  }
}
```

##### Object validation failed

```ruby
ShpApi::JsonResponder.new(self).model_error(message: "Invalid", model_errors: nil)
```

Returns status: 422 Unprocessable Entity

```JSON
{
  "status": "error",
  "data": {
    "message": "Invalid",
    "error_code": "invalid"
  }
}
```

The "data" element can also sometimes include an "errors" object containing
the name of the model who's validation failed and an array including the
specific validation errors:

```JSON
{
  "data": {
    "error_code": "invalid",
    "errors": {
      "rating": [
        "must be a number between 0 and 10"
      ]
    },
    "message": "Invalid"
  },
  "status": "error"
}
```

##### Object Conflict

```ruby
ShpApi::JsonResponder.new(self).conflict(message: "Conflict")
```

Returns status: 409 Conflict

```JSON
{
  "status": "error",
  "data": {
    "message": "Conflict",
    "error_code": "conflict"
  }
}
```

#### Other

##### 200 OK with an empty body

```ruby
ShpApi::JsonResponder.new(self).ok
```

Returns status: 200 OK with an empty body

This is used for returning a positive result to fx. a jQuery ajax request where
no return data is needed.


## Releasing a new version

* Bump version number in lib/shp_api/version.rb
* Bump version number in README (this file)
* Commit changes.
* git tag -a v<version_number>
* git push origin master
* git push --tags origin master


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
