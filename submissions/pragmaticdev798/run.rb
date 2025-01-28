require 'yaml'

# path for the yaml files
pattern = 'C:/Users/Transformer/Desktop/ruby-programming-challenge/db/**/*.yaml' 

count = 0
arr = []  # array for storing error messages related to filename mismatches
files = Dir.glob(pattern)  # load all yaml files recursively

files.each do |file|
  puts file
  count += 1
  begin
    content = YAML.load_file(file)
    base_name = File.basename(file, ".yaml")
    
    # check for name mismatch between the base file name and 'name' in the yaml content
    if content["name"] != base_name
      arr << "warning: file #{file} has a name mismatch, expected 'name' to be '#{base_name}', but got '#{content["name"]}'."
    end
  rescue => e
    puts "error reading #{file}: #{e.message}"
  end
end

puts "total number of instructions: #{count}"
puts "here are the conflicting files with basename mismatch error:"
arr.each { |error| puts error }

#loops and checks for extensions
puts "enter comma-separated extensions:"
input = gets.chomp
extensions = input.split(',').map(&:strip)

matching_instructions = []
files.each do |file|
  begin
    content = YAML.load_file(file)
    defined_by = content["definedBy"]
    if defined_by.is_a?(String)
      matching_instructions << content["name"] if extensions.include?(defined_by)
    elsif defined_by.is_a?(Hash)
      if defined_by["allOf"] && defined_by["allOf"].is_a?(Array)
        matching_instructions << content["name"] if (defined_by["allOf"] - extensions).empty?
      elsif defined_by["anyOf"] && defined_by["anyOf"].is_a?(Array)
        matching_instructions << content["name"] if (defined_by["anyOf"] & extensions).any?
      end
    end
  rescue => e
    puts "error reading #{file}: #{e.message}"
  end
end
puts "matching instructions:"
matching_instructions.each { |instruction| puts instruction }