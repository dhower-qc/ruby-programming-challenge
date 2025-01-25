'''
    Submitted by    : Muhammad Hammad Bashir
    github account  : https://github.com/MuhammadHammad001
'''
require "yaml"

def read_function(top_dir_path)
    all_data = {}
    # Iterate over each YAML file
    Dir.glob("#{top_dir_path}/**/*.yaml").each do |file_path|
        internal_yaml_data = YAML.load_file(file_path)

        # Generate relative path and split it
        relative_path = file_path.sub("#{top_dir_path}/", '')       # Remove base directory prefix
        dirs = File.dirname(relative_path)
        file_name = File.basename(relative_path, '.yaml')

        all_data[dirs] ||= {}           # Initialize if not exists
        all_data[dirs][file_name] = internal_yaml_data
    end

    all_data
end

def definedby_parser(definedby, ext_lst)
    case definedby
    when String
        #Find whether its a string or a hash.
        ext_lst.include?(definedby)
    when Hash
        #Recursion to solve it more effectively.
        if definedby.key?("allOf")
            definedby["allOf"].all? { |internal_definedby| definedby_parser(internal_definedby, ext_lst)}
        elsif definedby.key?("anyOf")
            definedby["anyOf"].any? { |internal_definedby| definedby_parser(internal_definedby, ext_lst)}
        else
            false
        end
    else
        false
    end
end

def print_instr_lst(input_hash, ext_lst)
    #iterate over the hash
    counter=0
    input_hash.each do |sub_dir, file_name|
        file_name.each do |instr, data|
            result = definedby_parser(data["definedBy"], ext_lst)
            if result
                counter+=1
                puts data['name']
            end
        end
    end
    #NOTE: This is extra effort, Not required in the assignment.
    puts("Total Number of instructions that cover the extension list #{ext_lst} are: #{counter}")
end

def total_files_calc(input_hash)
    curr_count = 0
    input_hash.each_key do |ext|
        curr_count+=input_hash[ext].length()
    end
    curr_count
end

def data_name_validator(dir, input_hash)
    input_hash.each do |ext, instrs|
        instrs.each do |instr, data|
            if instr != data["name"]
                warn "Warning!\n  #{data["name"]} does not match with the file name #{instr}\n  Please correct #{dir}/#{ext}/#{instr}"
            end
        end
    end
end

dir = File.join(File.dirname(__FILE__), '../../db')
dir = File.expand_path(dir)
'''
    Task 1: Read the data from all the YAML Files
'''
hash_container = read_function(dir)

puts ("---------------------------------------------------------------------------------")

'''
    Task 2: Print the number of files or instructions found.
'''
puts ("Total number of files under the db directory are: #{total_files_calc(hash_container)}")

puts ("---------------------------------------------------------------------------------")

'''
    Task 3: Throw a warning in case the instr name does not match its file name title.
'''
data_name_validator(dir, hash_container)

puts ("---------------------------------------------------------------------------------")

'''
    Task 4: Print instructions based on the extension name.
'''
print "Please enter an extension name or comma-seperated extension list: "
ext_lst = gets.chomp
ext_lst = ext_lst.split(",")

print_instr_lst(hash_container, ext_lst)

# puts ("---------------------------------------------------------------------------------")

