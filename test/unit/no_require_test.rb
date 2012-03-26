require 'test/unit'
require File.join( File.dirname( __FILE__ ), '..', '..', 'lib', 'no_require.rb' )

class NoRequireTest < Test::Unit::TestCase

  def setup
    @nr = NoRequire.new( '' )
  end
  
  def test_camelize
    assert_equal '', @nr.send( :camelize, "" )
    assert_equal "Apple", @nr.send( :camelize, "apple" )
    assert_equal "MyApple", @nr.send( :camelize, "my_apple" )
    assert_equal "Mybanana", @nr.send( :camelize, "MYBANANA")
  end

  def test_to_class_name_with_two_word_single_path_segment
    assert_equal "NoRequire", @nr.send( :to_class_name, "no_require" )
    assert_equal "::NoRequire", @nr.send( :to_class_name, "/no_require" )
  end

  def test_to_class_name_with_multiple_path_segments
    assert_equal "AModule::NoRequire", @nr.send( :to_class_name, "a_module/no_require" )
    assert_equal "BModule::AModule::NoRequire", @nr.send( :to_class_name, "b_module/a_module/no_require" )
  end

  def test_generate_autoload_for_with_simple_root_not_nested
    assert_equal "autoload :NoRequire, 'no_require.rb'", @nr.send( :generate_autoload_for, [], 'no_require.rb' )
  end

  def test_generate_autoload_for_with_simple_root_nested
    assert_equal "module ModuleOne; autoload :NoRequire, 'module_one/no_require.rb'; end",
                 @nr.send( :generate_autoload_for, [], 'module_one/no_require.rb' )
    assert_equal "module ModuleTwo; module ModuleOne; autoload :NoRequire, 'module_two/module_one/no_require.rb'; end; end",
                 @nr.send( :generate_autoload_for, [], 'module_two/module_one/no_require.rb' )
  end

  def test_generate_autoload_for_with_root_and_not_nested
    assert_equal "autoload :NoRequire, '/root/toot/no_require.rb'",
                 @nr.send( :generate_autoload_for, ['root', 'toot'], '/root/toot/no_require.rb' )
  end
end
