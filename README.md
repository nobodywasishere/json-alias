# JSON::Alias

Macro for generating an alias type from JSON/YAML. Useful for parsing JSON/YAML without needing to manually create a type alias or parse by hand.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     json-alias:
       github: nobodywasishere/json-alias
   ```

2. Run `shards install`

## Usage

Generate an alias from a JSON/YAML file at compile time:

```crystal
require "json"
require "json-alias"

class TestClass
  # alias JsonData = Array(Hash(String, Int32 | String) | Hash(String, Int32) | Hash(String, String))
  # Need to pass absolute path to example, hence __DIR__
  JSON::Alias.from_json JsonData, "#{__DIR__}/example.json"

  # alias YamlData = Array(Hash(String, Int32 | String) | Hash(String, Int32) | Hash(String, String))
  JSON::Alias.from_yaml YamlData, "#{__DIR__}/example.yaml"

  getter json : JsonData
  getter yaml : YamlData

  def initialize
    data = File.read("#{__DIR__}/data.json")

    @json = JsonData.from_json(data)
    @yaml = YamlData.from_json(data)
  end
end

tc = TestClass.new

puts tc.json
puts tc.yaml

puts "Success."
```

Tool for generating type from command-line:

```bash
$ shards build parse_data --release
$ ./bin/parse_data --file spec/example.json --type json

Array(Hash(String, Int32 | String) | Hash(String, Int32) | Hash(String, String))
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/nobodywasishere/json-alias/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Margret Riegert](https://github.com/nobodywasishere) - creator and maintainer
