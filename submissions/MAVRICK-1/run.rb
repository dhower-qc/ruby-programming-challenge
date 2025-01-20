# frozen_string_literal: true

require 'yaml'
require 'set'

# Parses `definedBy` conditions
class DefinedByParser
  def self.parse(defined_by)
    case defined_by
    when String
      [defined_by]
    when Array
      defined_by.compact.flat_map { |entry| parse(entry) }
    when Hash
      if defined_by.key?('allOf')
        defined_by['allOf'].flat_map { |entry| parse(entry) }
      elsif defined_by.key?('anyOf')
        defined_by['anyOf'].flat_map { |entry| parse(entry) }
      else
        raise "Unexpected structure in definedBy: #{defined_by.inspect}"
      end
    else
      raise "Invalid type in definedBy: #{defined_by.inspect}"
    end
  end
end

# Loads and processes RISC-V instruction YAML files
class RiscVInstructionLoader
  attr_reader :directory, :yaml_files, :instructions

  def initialize(directory: 'db/')
    @directory = directory
    @yaml_files = []
    @instructions = []
  end

  def load_yaml_files
    @yaml_files = Dir.glob(File.join(@directory, '**', '*.yaml'))
  end

  def load_instructions
    @instructions = @yaml_files.each_with_object([]) do |file, arr|
      begin
        content = YAML.load_file(file)
        arr << content
      rescue StandardError => e
        puts "Error loading file #{file}: #{e.message}"
      end
    end
  end

  def print_yaml_summary
    puts "Number of YAML files loaded: #{@yaml_files.size}"
    puts "Number of instructions found: #{@instructions.size}"
  end

  def validate_instruction_names
    @yaml_files.each do |file|
      yaml_content = YAML.load_file(file)
      file_name = File.basename(file, '.yaml')
      unless yaml_content['name'] == file_name
        puts "Warning: name key does not match file name in #{file}"
      end
    end
  end

  def filter_instructions_by_extensions
    print 'Enter a comma-separated list of extensions to search for: '
    extensions = gets.chomp.split(',').map(&:strip)
    return if extensions.empty?

    matching_instructions = find_instructions_by_extensions(extensions)
    puts "\nInstructions matching the provided extensions:"
    matching_instructions.each { |instruction| puts instruction['name'] }
  end

  private

  def find_instructions_by_extensions(extensions)
    extensions_set = extensions.to_set
    @instructions.select do |instruction|
      defined_by = instruction['definedBy']
      next false if defined_by.nil?

      defined_extensions = DefinedByParser.parse(defined_by).to_set
      (defined_extensions & extensions_set).any?
    end
  end
end

# Run the script if executed directly
if __FILE__ == $PROGRAM_NAME
  loader = RiscVInstructionLoader.new

  loader.load_yaml_files
  loader.load_instructions
  loader.print_yaml_summary
  loader.validate_instruction_names
  loader.filter_instructions_by_extensions
end
