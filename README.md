# SHMTools

Utility functions for inquiring and manipulating POSIX Shared Memory

## Installation

Add this line to your application's Gemfile:

    gem 'shmtools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shmtools

## Usage

```ruby
require 'shmtools'

# Get array of info structs on visible shared memory segments
segments = SHMTools::shm_segments
```

TODO: Write more usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
