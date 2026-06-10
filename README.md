# Wrails

Rails but worse

---

## Installation

```ruby
gem 'wrails'
gem 'puma'
```

```bash
bundle install
```

---

## Usage

```ruby
require 'wrails'

Wrails::Routes.get '/' do
  'Home Page'
end

Wrails.run!
```
