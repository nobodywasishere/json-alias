require "json"

# TODO: Write documentation for `JSON::Alias`
module JSON::Alias
  VERSION = "0.1.0"

  macro from_json(type, file)
    alias {{type}} = {{ run("#{__DIR__}/json-alias/parse_data.cr", "--file", file, "--type", "json") }}
  end

  macro from_yaml(type, file)
    alias {{type}} = {{ run("#{__DIR__}/json-alias/parse_data.cr", "--file", file, "--type", "yaml") }}
  end
end
