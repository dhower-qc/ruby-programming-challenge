require 'minitest/autorun'
require_relative 'parser'
require 'yaml'

class TestRiscVInstructionLoader < Minitest::Test
  def setup
    @test_dir = "test_db"
    Dir.mkdir(@test_dir) unless Dir.exist?(@test_dir)

    # Create sample YAML files for testing
    File.write(File.join(@test_dir, "add.yaml"), { "name" => "add", "definedBy" => "A" }.to_yaml)
    File.write(File.join(@test_dir, "sub.yaml"), { "name" => "sub", "definedBy" => "B" }.to_yaml)
    File.write(File.join(@test_dir, "mul.yaml"), { "name" => "mul", "definedBy" => { "anyOf" => ["A", "C"] } }.to_yaml)


    @loader = RiscVInstructionLoader.new(@test_dir)
    @loader.load_files
  end

  def teardown
   
    Dir.foreach(@test_dir) { |f| File.delete(File.join(@test_dir, f)) unless File.directory?(f) }
    Dir.rmdir(@test_dir)
  end

  # Test to verify correct loading of YAML files
  def test_yaml_loading
    assert_equal 3, @loader.files.size, "Should load 3 YAML files"
    assert_equal 3, @loader.instructions.size, "Should store 3 instructions"
  end

  # Test filtering by a single extension (A)
  def test_filter_by_single_extension
    result = capture_io { @loader.filter_by_extensions("A") }.join
    assert_includes result, "INSTRUCTION 'add' MATCHING [\"A\"] FOUND IN add.yaml"
    assert_includes result, "INSTRUCTION 'mul' MATCHING [\"A\"] FOUND IN mul.yaml"
    refute_includes result, "sub.yaml"
  end

  # Test filtering by multiple extensions (A, C)
  def test_filter_by_multiple_extensions
    result = capture_io { @loader.filter_by_extensions("A, C") }.join
    assert_includes result, "INSTRUCTION 'mul' MATCHING [\"A\", \"C\"] FOUND IN mul.yaml"
  end

  def test_invalid_extension
    result = capture_io { @loader.filter_by_extensions("X") }.join
    assert_includes result, "❌ No matching instructions found."
  end

  # New test to verify the integrity of YAML files in the db directory
  def test_yaml_integrity
    db_path = File.expand_path("../../db", __dir__)
    yaml_files = Dir.glob(File.join(db_path, "**", "*.yaml"))
    
    yaml_files.each do |file|
      begin
        YAML.load_file(file)
      rescue Psych::SyntaxError => e
        flunk "YAML Syntax Error in #{file}: #{e.message}"
      end
    end
    assert true, "All YAML files are valid."
  end
end
