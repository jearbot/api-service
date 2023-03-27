Local Testing
* Add `.env.rb` file in `config/env.rb`
* Add `ENV['API_TOKEN'] = 'a_random_api_token'` to `.env.rb`

Testing without OpenRoute callbacks:
* Create Drivers
```ruby
require 'factory_bot'
d = FactoryBot.create(:driver)
50.times do 
  FactoryBot.create(:ride, driver: d)
end
```
```
curl -X GET
-H 'X-ACCESS-TOKEN: YOUR_API_TOKEN'
-d 'driver_id="DRIVER_EXTERNAL_ID_OR_ID"'
'http://localhost:3000/api/v1/rides?page=1'
```
---
Local testing with OpenRoute callbacks:
* Add `ENV['OPENROUTE_TOKEN'] = 'your_openroute_api_token'` to `.env.rb`
* Create Drivers
```ruby
require 'factory_bot'
d = FactoryBot.create(:driver_with_callbacks)
15.times do 
  FactoryBot.create(:ride_with_callbacks, driver: d)
end
```
```
curl -X GET
-H 'X-ACCESS-TOKEN: YOUR_API_TOKEN'
-d 'driver_id="DRIVER_EXTERNAL_ID_OR_ID"'
'http://localhost:3000/api/v1/rides?page=1'
```
---
Feel free to test this out on Heroku as well using this CURL command:
```
curl -X GET
-H 'X-ACCESS-TOKEN: cc52f47e-e6d1-4bca-a928-b24cfdfdcc4f'
-d 'driver_id="D-27LYR1HRLR"'
'https://hsd-homework.herokuapp.com/api/v1/rides/?page=1'
```
---
## Drivers API

### Show Driver

Returns a JSON object containing a list of rides associated with a driver.

* URL  
`http://localhost:3000/api/v1/rides/:driver_id`

* Method  
`GET`

* URL Params  
     * `driver_id`
          * Required: `yes`
          * Type: `string`
          * Example: `"D-1234567890"`
     * `page`
          * Required: `no`
          * Type: `integer`
          * Example: `"1"`

* Headers (Authentication token required for accessing protected resources)
     * Required: `yes` 
     * Example: `['X-ACCESS-TOKEN']="your_secret_token_here"`
  

* Success Response  
    * Code: 200  
    * Content: 
```json
{
  "rides": [
    {
      "id": 1,
      "start_address": "123 Main St.",
      "destination_address": "456 Elm St.",
      "distance": 10.0,
      "duration": 20,
      "status": "completed",
      "created_at": "2023-03-25T12:00:00Z",
      "updated_at": "2023-03-25T12:10:00Z",
      "driver_id": 1
    },
    {
      "id": 2,
      "start_address": "789 Oak St.",
      "destination_address": "101 Maple St.",
      "distance": 5.0,
      "duration": 10,
      "status": "completed",
      "created_at": "2023-03-26T12:00:00Z",
      "updated_at": "2023-03-26T12:10:00Z",
      "driver_id": 1
    }
  ],
  "meta": {
    "current_page": 1,
    "next_page": 2,
    "prev_page": null,
    "total_pages": 2,
    "total_count": 20
  }
}
```

* Error Response
     * Code: 401 Unauthorized  
     * Content:
```json
{
  "error": "Authentication is required"
}
```

* Not Found Response
     * Code: 404 Not Found  
     * Content:
```json
{
  "error": "Not Found"
}
```

* Sample call using Ruby

```ruby
require 'uri'
require 'net/http'

url = URI("http://localhost:3000/api/v1/rides/D-1234567890?page=1")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["Authorization"] = "Bearer [token]"

response = http.request(request)
puts response.read_body
```

* Sample call using CURL

```
curl -X GET
-H 'X-ACCESS-TOKEN: 11111111-2222-3333-4444-555555555555'
-d 'driver_id="D-1234567890"'
'http://localhost:3000/api/v1/rides?page=1'
```
