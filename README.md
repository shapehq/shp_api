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

### Json Responses

The gem includes responses for the most common Api responses which are callable
from any Rails controller.

#### 200 OK with an empty body

```ruby
ShpApi::JsonResponder.new(self).ok
```

#### Update single objects

```ruby
ShpApi::JsonResponder.new(self).no_content
```

Returns status: 204 No Content with an empty body

#### Create single object

```ruby
ShpApi::JsonResponder.new(self).created
```

Returns status: 201 Created with an empty body

#### User not signed in

```ruby
ShpApi::JsonResponder.new(self).unauthorized(message: "Unauthorized", error_code: "unauthorized")
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

#### Conflict

```ruby
ShpApi::JsonResponder.new(self).conflict(message: "Conflict", error_code: "conflict")
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

#### Custom error

```ruby
ShpApi::JsonResponder.new(self).error(message: "Not specified", error_code: "not_specified", status: 400)
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

#### Update single object failed

```ruby
ShpApi::JsonResponder.new(self).model_error(message: "Invalid", error_code: "invalid", model_errors: nil, status: 422)
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

#### Insufficient user rights

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

#### Required parameters missing

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

#### Not found

```ruby
ShpApi::JsonResponder.new(self).not_found(exception: nil, error_code: "not_found")
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

#### Internal Server Error

```ruby
ShpApi::JsonResponder.new(self).exception(exception: nil)
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
