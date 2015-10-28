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

##### 200 OK with data

```ruby
data = User.all.as_json(include: [:device_tokens])
meta = { :current_page => 1 }
ShpApi::JsonResponder.new(self).data(data: data, meta: meta, status: :ok)
```

Returns status: 200 OK with a body:
```JSON
{
  "status": "success",
  "meta": {
    "current_page": 1,
    "total_page_count": 3,
    "page_record_count": 25,
    "total_record_count": 53,
    "links": {
      "next": "http://localhost:3000/api/v1/users?page=2&per_page=25",
      "prev": null,
      "last": "http://localhost:3000/api/v1/users?page=3&per_page=25",
      "first": "http://localhost:3000/api/v1/users?page=1&per_page=25"
    }
  },
  "data": [
    {
      "id": 1,
      "email": "gert+user@shape.dk",
      "name": "Gert User Jørgensen",
      "created_at": "2015-10-26T13:45:27.789Z",
      "updated_at": "2015-10-26T13:45:27.789Z",
      "device_tokens": [
        {
          "id": 1,
          "token": "token-1445873776",
          "platform": "apns"
        }
      ]
    }
  ]
}
```

This is used for returning a positive result to fx. a jQuery ajax request where
no return data is needed.


## Releasing a new version

* Bump version number in lib/shp_api/version.rb
* Commit changes & push changes.
* git tag -a v&lt;version_number&gt;
* git push origin master
* git push --tags origin master


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
