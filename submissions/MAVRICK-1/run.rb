require 'yaml'
require 'set'

def load_yaml_files(directory)
  Dir.glob(File.join(directory, '**', '*.yaml'))
end

def validate_instruction_name(file_path)
  yaml_content = YAML.load_file(file_path)
  file_name = File.basename(file_path, '.yaml')
  yaml_content['name'] == file_name
end

def parse_defined_by(defined_by)
    case defined_by
    when String
      [defined_by]
    when Array
      defined_by.compact.flat_map { |entry| parse_defined_by(entry) }
    when Hash
      if defined_by.key?('allOf')
        defined_by['allOf'].flat_map { |entry| parse_defined_by(entry) }
      elsif defined_by.key?('anyOf')
        defined_by['anyOf'].flat_map { |entry| parse_defined_by(entry) }
      else
        raise "Unexpected structure in definedBy: #{defined_by.inspect}"
      end
    else
      raise "Invalid type in definedBy: #{defined_by.inspect}"
    end
  end

def find_instructions_by_extensions(instructions, extensions)
  extensions_set = extensions.to_set
  instructions.select do |instruction|
    defined_by = instruction['definedBy']
    next false if defined_by.nil?

    defined_extensions = parse_defined_by(defined_by).to_set
    (defined_extensions & extensions_set).any?
  end
end

# Main script logic
db_directory = 'db/'
yaml_files = load_yaml_files(db_directory)
instructions = []

yaml_files.each do |file|
  begin
    content = YAML.load_file(file)
    instructions << content
  rescue StandardError => e
    puts "Error loading file #{file}: #{e.message}"
  end
end

puts "Number of YAML files loaded: #{yaml_files.size}"
puts "Number of instructions found: #{instructions.size}"

# Validate name key
yaml_files.each do |file|
  unless validate_instruction_name(file)
    puts "Warning: name key does not match file name in #{file}"
  end
end

# Request and process extensions
puts 'Enter a comma-separated list of extensions to search for:'
extensions_input = gets.chomp
extensions = extensions_input.split(',').map(&:strip)

matching_instructions = find_instructions_by_extensions(instructions, extensions)
puts "Instructions defined by the provided extensions:"
matching_instructions.each do |instruction|
  puts instruction['name']
end
