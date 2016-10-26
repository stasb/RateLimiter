# AirTasker 'Rate Limiter' Coding Challenge Solution by Stas Belkov

## Solution Outline

I went with a simple approach that does not depend on any caching layers, but uses the PostgreSQL database to keep track of requests for throttling.

I created a module in the lib directory, which is included in ApplicationController. This module encapsulates a class (to avoid the controller calling private methods),
which does the logic behind the throttling.

I rely on a throttle_log PG table, which stores ip_address, expiry_time, and count. When a request occurs, a ThrottleLog record is created,
and then subsequently updated to keep track of the requests within the 1 hour period, for this IP. When the expiry period is over, both the count and expiry time are reset. I have indexed the
ip_address column on the throttle_log table for fast lookup.

The rate throttler module is included in ApplicationController, where a private method is defined that responds with the correct 429 HTTP code and error message. This method is set as a before_action
within HomeController, which runs before the #index action.

I have written specs that test both the throttler class, as well as the controller method itself. These tests a range of scenarios and logic paths. I used the Timecop gem in the module spec, in order to simulate moving past the expiry time, and testing
for the correct detection of a throttle event.

## How to run

1. `bundle install`
2. `bundle exec rake db:setup`
3. `bundle exec rake db:migrate`
4. `bundle exec rails s`
5. Visit localhost:3000 at the root path

## Tests

`bundle exec rspec`

## Potential improvements

- offload throttle log persistence to Redis or similar memory store, for performance improvements and offloading work from the primary database
- implement throttle logic within the Rack layer, as opposed to a lib module
- have greater customisation of throttling logic, so that different limits can be imposed across varied controllers and actions. A DSL could be implemented for easy declaration of throttle logic within
the app, which I have noticed the popular throttling gems do
