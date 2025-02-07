require 'yaml'
require 'rubygems'
require 'bundler/setup'
require 'oj'
require 'set'
require 'colorize'

# Recursively fetch all YAML files from the given directory
def get_yaml_files(directory)
    Dir.glob(File.join(directory, "**", "*.yaml"))
end
  
class RiscVInstructionLoader
  attr_reader :instructions, :files

  def initialize(directory)
    @directory = directory
    @instructions = []
    @files = []
  end

  # Load all YAML files and store instructions
  def load_files
    @files = get_yaml_files(@directory)
    @files.each do |file|
      begin
        content = File.read(file)
        data = parse_yaml(content)
        validate_filename(file, data)
        @instructions << { file: file, data: data }
      rescue StandardError => e
        puts "❌ Error loading #{file}: #{e.message}".red
      end
    end
  end

  # Try parsing with Oj first, then fallback to YAML
  def parse_yaml(content)
    Oj.load(content) # Fast parsing
  rescue
    YAML.load(content) # Fallback if Oj fails
  end

  # Ensure the filename matches the instruction name inside YAML
  def validate_filename(file, data)
    expected_name = File.basename(file, ".yaml")
    if data["name"] != expected_name
      puts "⚠️  Warning: #{file} has mismatched name key (expected '#{expected_name}', found '#{data['name']}')".yellow
    end
  end

  # Print summary of loaded files and instructions
  def print_summary
    puts "📂 Total YAML files loaded: #{@files.size}".cyan
    puts "📜 Total instructions loaded: #{@instructions.size}".cyan
  end

  # Filter and display instructions that match user-provided extensions
  def filter_by_extensions(extensions)
    extensions = extensions.split(',').map(&:strip)
    matching_instructions = @instructions.select do |instr|
      defined_by = instr[:data]["definedBy"]
      match_extension?(defined_by, extensions)
    end

    puts "\n🔍 Instructions matching extensions #{extensions.inspect}:".light_blue
    if matching_instructions.empty?
      puts "❌ No matching instructions found.".red
    else
      matching_instructions.each do |instr|
        file_name = File.basename(instr[:file])
        instruction_name = instr[:data]["name"]
        puts "✅ INSTRUCTION '#{instruction_name}' MATCHING #{extensions.inspect} FOUND IN #{file_name}".green
      end
    end
  end

  private

  # Check if an instruction matches the given extensions
  def match_extension?(defined_by, extensions)
    case defined_by
    when String
      extensions.include?(defined_by)
    when Hash
      match_hash(defined_by, extensions)
    else
      false
    end
  end

  # Handle nested extension conditions (allOf / anyOf logic)
  def match_hash(defined_by, extensions)
    if defined_by.key?("allOf")
      defined_by["allOf"].all? { |ext| match_extension?(ext, extensions) }
    elsif defined_by.key?("anyOf")
      defined_by["anyOf"].any? { |ext| match_extension?(ext, extensions) }
    else
      false
    end
  end
end

if __FILE__ == $0
  db_path = File.expand_path("../../db", __dir__) # Dynamically set db path
  puts "🗂️  Loading YAML files from: #{db_path}".cyan

  loader = RiscVInstructionLoader.new(db_path)
  loader.load_files
  loader.print_summary
  
  print "\n💡 Enter comma-separated extension names: ".light_blue
  extensions = gets.chomp
  loader.filter_by_extensions(extensions)
end
