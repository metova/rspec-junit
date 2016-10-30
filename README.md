## RSpec::JUnit

This gem provides a custom JUnit formatter for RSpec >= 3.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-junit'
```

And then bundle.

### Usage

RSpec uses the `-f` flag to specify a formatter and the `-o` flag to specify an output:

```
bin/rspec -f RSpec::JUnit -o results/rspec-junit.xml
```
