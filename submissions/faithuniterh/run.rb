#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
require 'yaml'
require 'set'
require 'psych'

# get number of yaml files
Dir.chdir(Pathname.getwd.parent.parent.children[1])
number_of_yaml_files = Dir[File.join(Pathname.getwd, '**', '*')].count do |file|
  File.file?(file) && File.extname(file) == '.yaml'
end
puts "the number of yaml files/instructions are #{number_of_yaml_files}"

# read yaml files and show warnings if name: does not match base filename
Pathname.getwd.children.each do |child_path|
  Dir.chdir(child_path)
  Dir.entries(Dir.pwd).select { |f| File.file?(f) && File.extname(f) == '.yaml' }.each do |yaml_file|
    complete_yaml_path = File.join(child_path, yaml_file)
    yaml_object = YAML.load_file(complete_yaml_path)
    if yaml_object['name'] != File.basename(complete_yaml_path, '.yaml')
      puts "#{yaml_object['name']} does not match #{File.basename(complete_yaml_path,
                                                                  '.yaml')} which is found at #{complete_yaml_path}"
    end
  end
end

# Ask for a list of extension names and prints out instructions/yaml files defined by those instructions
# check definedBy value in the Yaml object
# if definedBy: Zba then defined by Zba implementation
# if definedBy: { allOf: [F,Zfa]} then defined if both F and Zfa are implemented
# if definedBy: { anyOf: [B, Zba ]} then instruction is defined
# if either B or Zba are implemented
# if definedBy: { anyOf: [B, {allOf: [Zba,Zbb]}]} then instruction is defined if
# either B is implemented or both Zba and Zbb are implemented

print "Enter list of extensions , separated by commas to get instructions/yaml files that implement them.
If you don't want to search for files with the input extensions press enter to close program: "
input = gets.chomp
list_of_extensions = input.split(',').map(&:strip) # Split by commas and remove extra spaces

if list_of_extensions.empty?
  puts 'Thank you for using our program. Execution ends here'
  exit!(0)
else
  list_of_extensions = list_of_extensions.map(&:to_s)
  puts "Your list of extensions is: #{list_of_extensions.inspect}"
end

Dir.chdir(Pathname.getwd.parent)

# read yaml files and check definedBy values
Pathname.getwd.children.each do |child_path|
  Dir.chdir(child_path)
  Dir.entries(Dir.pwd).select { |f| File.file?(f) && File.extname(f) == '.yaml' }.each do |yaml_file|
    complete_yaml_path = File.join(child_path, yaml_file)
    yaml_object = Psych.safe_load_file(complete_yaml_path, permitted_classes: [Hash, Array])
    if yaml_object['definedBy'].is_a?(String)
      if list_of_extensions.length == 1 && list_of_extensions.include?(yaml_object['definedBy'])
        puts "Yaml file with extension #{list_of_extensions.inspect} also has the following extensions #{yaml_object['definedBy']} and is found at #{complete_yaml_path}"
      end

    elsif Set.new(list_of_extensions).eql?(Set.new(yaml_object['definedBy']['allOf']))
      # check with list_of_extensions if both are there
      # puts "defined by multiple extensions #{yaml_object['definedBy']} yaml is at #{complete_yaml_path}"
      puts "Yaml file with extension #{list_of_extensions.inspect} also has the following extensions #{yaml_object['definedBy']} and is found at #{complete_yaml_path}"

    elsif Set.new(list_of_extensions).subset?(Set.new(yaml_object['definedBy']['anyOf']))
      # check if either are implemented
      puts "Yaml file with extension #{list_of_extensions.inspect} also has the following extensions #{yaml_object['definedBy']} and is found at #{complete_yaml_path}"

    elsif !yaml_object['definedBy']['anyOf'].nil? && Set.new(list_of_extensions).eql?(Set.new(yaml_object['definedBy']['anyOf'][1]['allOf']))
      # uses either or and both extensions
      # puts "combines either or and and #{yaml_object['definedBy']} yaml is at #{complete_yaml_path}"
      puts "Yaml file with extension #{list_of_extensions.inspect} also has the following extensions #{yaml_object['definedBy']} and is found at #{complete_yaml_path}"
    end
  end
end
