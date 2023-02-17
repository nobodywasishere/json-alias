require "json"
require "yaml"
require "option_parser"

file_type = "json"
file_name = ""

OptionParser.parse do |parser|
  parser.banner = "Usage: salute [arguments]"
  parser.on("-t type", "--type=type", "Type of file to parse (json, yaml)") { |type| file_type = type }
  parser.on("-f name", "--file=name", "File to parse") { |name| file_name = name }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

if file_name == ""
  STDERR.puts "--file filename required"
  exit(1)
end

case file_type
when "json"
  file = JSON.parse(File.read(file_name))
when "yaml"
  file = YAML.parse(File.read(file_name))
else
  STDERR.puts "JSONAlias only supports YAML and JSON"
  exit(1)
end

def parse(token) : String
  if !token.is_a? JSON::Any && !token.is_a? YAML::Any
    # Return pre-parsed literals, can happen with arrays and hash keys
    return token.class.to_s
  elsif token.nil? || token.inspect == "nil"
    # Sometimes there are empty tokens
    return "Nil"
  elsif token.as_s?
    return token.as_s.class.to_s
  elsif token.as_i?
    return token.as_i.class.to_s
  elsif token.as_f?
    return token.as_f.class.to_s
  elsif !token.as_bool?.nil?
    # Need to explicitly check if not nil as `false` will fail to branch
    return token.as_bool.class.to_s
  elsif token.as_a?
    # Recursively check arrays, removing duplicate values
    parsed_arr = token.as_a
      .map { |t| parse(t) }
      .sort.uniq.select { |t| t != "" }
    # Sometimes recursion returns an empty value
    parsed_arr = ["Nil"] if parsed_arr.size == 0

    return "Array(#{parsed_arr.join(" | ")})"
  elsif token.as_h?
    # Recursively check hash keys, removing duplicates
    parsed_key = token.as_h
      .map { |k, v| parse(k) }
      .sort.uniq.select { |t| t != "" }
    parsed_key = ["Nil"] if parsed_key.size == 0

    # Recursively check hash values, removing duplicates
    parsed_val = token.as_h
      .map { |k, v| parse(v) }
      .sort.uniq.select { |t| t != "" }
    parsed_val = ["Nil"] if parsed_val.size == 0

    return parsed_key
      .map { |key| "Hash(#{key}, #{parsed_val.join(" | ")})" }
      .join(" | ")
  else
    # We shouldn't reach here, but return something anyways
    return token.to_s
  end
end

puts parse(file)
