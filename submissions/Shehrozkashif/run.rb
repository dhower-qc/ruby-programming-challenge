require 'yaml'

DB_DIRECTORY = 'db/'

yaml_files = Dir.glob("#{DB_DIRECTORY}/*.yaml")
instructions = []

yaml_files.each do |file_path|
  instruction_data = YAML.load_file(file_path)
  instruction_name = instruction_data['name']
  filename_without_extension = File.basename(file_path, ".yaml")

  if instruction_name != filename_without_extension
    puts "⚠️  Warning: #{filename_without_extension}.yaml has a mismatched name: #{instruction_name}"
  end

  instructions << instruction_data
end

puts "✅ Successfully loaded #{yaml_files.size} YAML files containing #{instructions.size} instructions."

print "Enter a comma-separated list of extensions: "
user_input = gets.chomp
selected_extensions = user_input.split(",").map(&:strip)

def matches_extension?(defined_by, selected_extensions)
  case defined_by
  when String
    selected_extensions.include?(defined_by)
  when Hash
    if defined_by.key?('allOf')
      defined_by['allOf'].all? { |ext| matches_extension?(ext, selected_extensions) }
    elsif defined_by.key?('anyOf')
      defined_by['anyOf'].any? { |ext| matches_extension?(ext, selected_extensions) }
    else
      false
    end
  else
    false
  end
end

matching_instructions = instructions.select do |instr|
  matches_extension?(instr['definedBy'], selected_extensions)
end

if matching_instructions.empty?
  puts "❌ No instructions found for the selected extensions."
else
  puts "✅ Instructions matching extensions #{selected_extensions.join(', ')}:"
  matching_instructions.each { |instr| puts "- #{instr['name']}" }
end
