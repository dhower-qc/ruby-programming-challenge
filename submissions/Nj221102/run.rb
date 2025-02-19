# frozen_string_literal: true

require 'pathname'
require 'yaml'
require 'set'
require 'psych'

class RiscVInstructionLoader
  
  def initialize(directory: Pathname.pwd)  # Optional argument to specify a custom directory for the YAML files,  Defaults to the current directory if not provided.
    @directory = directory
    @yaml_files = []
  end

  def load_yaml_files
    @yaml_files = Dir.glob(File.join(@directory, '**', '*.yaml'))
  end

  def print_yaml_count
    puts "The number of YAML files found: #{@yaml_files.count}"
  end

  def print_filename_warnings
    @yaml_files.each do |yaml_file|
      yaml_object = load_yaml(yaml_file)
      base_filename = File.basename(yaml_file, '.yaml')
      if yaml_object['name'] != base_filename
        puts "#{yaml_object['name']} does not match the base filename #{base_filename} in #{yaml_file}"
      end
    end
  end

  def filter_instructions_by_extension
    print "Enter list of extensions (comma-separated) to filter instructions: "
    input = gets.chomp
    return if input.strip.empty?
    
    extensions = input.split(',').map(&:strip)
    puts "You entered the following extensions: #{extensions.inspect}"

    # Counter to track number of matches
    matches_count = 0

    @yaml_files.each do |yaml_file|
      yaml_object = load_yaml(yaml_file)
      if defined_by_match?(yaml_object['definedBy'], extensions)
        puts "Instruction defined by #{extensions.inspect} found in #{yaml_file}"
        matches_count += 1 
      end
    end

    # Print the number of matches
    puts "Total instructions matching the provided extensions: #{matches_count}"

  end

  private

  def load_yaml(yaml_file)
    YAML.safe_load(File.read(yaml_file), permitted_classes: [Hash, Array])
  end

  def defined_by_match?(defined_by, extensions)
    return extensions.include?(defined_by) if defined_by.is_a?(String)

    case defined_by
    when Hash
      if defined_by.key?('allOf')
        Set.new(defined_by['allOf']).subset?(Set.new(extensions))
      elsif defined_by.key?('anyOf')
        Set.new(defined_by['anyOf']).intersect?(Set.new(extensions))
      else
        false
      end
    else
      false
    end
  end
end

if __FILE__ == $PROGRAM_NAME   # This check ensures that the code in this block runs only when the script is executed directly and not when it's loaded as a module in another script.

  loader = RiscVInstructionLoader.new   # Creates a new instance (object) of the RiscVInstructionLoader class.

  loader.load_yaml_files

  loader.print_yaml_count

  loader.print_filename_warnings   # checks if the name key in the YAML matches the filename (without the .yaml extension).

  loader.filter_instructions_by_extension
end
