# Malartu

Malartu API makes it easy to interact with the [Malartu](https://www.malartu.co/). This gem is a ruby wrapper for the [Malartu API](https://app.malartu.co/docs/api).

Some examples of what you can do with the Malartu API:

* Track custom metrics to be aggregated into your other integrations. See what [integration Malartu provides](https://www.malartu.co/integrations/)
* View your aggregated metrics
* View your reports created in Malartu

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'malartu'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install malartu

## Usage

Set your apikey
`Malartu.apikey = 'XXXXX-XXXXXXXXXXXXXXX'`

Start extending your usage with the Malartu API
```
Malartu::Metric.uids # valid uids you are tracking in Malartu
Malartu::Metric.list(starting: (Date.today - 5.days).to_s, ending: Date.today.to_s, uids: ['arr', 'mrr'])
Malartu::Tracking::Data.list(starting: (Date.today - 5.days).to_s, ending: Date.today.to_s)
Malartu::Schedule.list
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidrichey/malartu-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
