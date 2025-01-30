require 'yaml'
require 'find'

DB_DIRECTORY = '/home/shehroz/Desktop/lfx/ruby-programming-challenge/db'

# Recursively find all YAML files inside db/ and its subdirectories
yaml_files = []
Find.find(DB_DIRECTORY) do |path|
  yaml_files << path if path.end_with?('.yaml')
end

instructions = []

# Load instructions and check name mismatches
yaml_files.each do |file_path|
  begin
    instruction_data = YAML.load_file(file_path)
    next unless instruction_data.is_a?(Hash) && instruction_data['name']

    instruction_name = instruction_data['name']
    filename_without_extension = File.basename(file_path, ".yaml")

    if instruction_name != filename_without_extension
      puts "⚠️  Warning: #{filename_without_extension}.yaml has a mismatched name: #{instruction_name}"
    end

    instructions << instruction_data
  rescue StandardError => e
    puts "❌ Error loading #{file_path}: #{e.message}"
  end
end

puts "✅ Successfully loaded #{yaml_files.size} YAML files containing #{instructions.size} instructions."

# Ask user for a list of extensions
print "Enter a comma-separated list of extensions: "
user_input = gets.chomp
selected_extensions = user_input.split(",").map(&:strip)

# Function to check if an instruction matches the selected extensions
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

# Filter instructions by selected extensions
matching_instructions = instructions.select do |instr|
  defined_by = instr['definedBy']
  defined_by && matches_extension?(defined_by, selected_extensions)
end

# Print matching instructions
if matching_instructions.empty?
  puts "❌ No instructions found for the selected extensions."
else
  puts "✅ Instructions matching extensions #{selected_extensions.join(', ')}:"
  matching_instructions.each { |instr| puts "- #{instr['name']}" }
end
