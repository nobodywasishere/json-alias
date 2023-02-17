require "json"
require "../src/json-alias"

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
