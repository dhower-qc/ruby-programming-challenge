require 'yaml'

class InstructionProcessor
  def initialize
    @instructions = load_instructions
  end

  def load_instructions
    files = Dir.glob('../../db/**/*.yaml')
    files.map do |file|
      content = YAML.load_file(file)
      content['_filename'] = File.basename(file, '.yaml')
      content
    end
  end

  def print_instruction_count
    puts "Found #{@instructions.length} instruction files"
  end

  def check_names
    @instructions.each do |instruction|
      if instruction['name'] != instruction['_filename']
        puts "WARNING: Filename '#{instruction['_filename']}.yaml' does not match instruction name '#{instruction['name']}'"
      end
    end
  end

  def matches_extension_rules?(defined_by, extensions)
    case defined_by
    when String
      extensions.include?(defined_by)
    when Hash
      if defined_by.key?('allOf')
        defined_by['allOf'].all? { |rule| matches_extension_rules?(rule, extensions) }
      elsif defined_by.key?('anyOf')
        defined_by['anyOf'].any? { |rule| matches_extension_rules?(rule, extensions) }
      else
        false
      end
    else
      false
    end
  end

  def find_matching_instructions(extensions)
    matching = @instructions.select do |instruction|
      matches_extension_rules?(instruction['definedBy'], extensions)
    end

    puts "\nInstructions defined by #{extensions.join(', ')}:"
    if matching.empty?
      puts "No matching instructions found"
    else
      matching.each do |instruction|
        puts "- #{instruction['name']}"
      end
    end
  end

  def run
    print_instruction_count
    puts
    check_names
    
    print "\nEnter comma-separated list of extensions (e.g., Zba,F,Zbb): "
    extensions = gets.chomp.split(',').map(&:strip)
    find_matching_instructions(extensions)
  end
end

# Run the program
processor = InstructionProcessor.new
processor.run