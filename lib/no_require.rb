class NoRequire
  
  def initialize( root, autoload_dirs=nil )
    @root = root
    no_require_dir( autoload_dirs ) unless autoload_dirs.nil?
  end

  def no_require_dir( *autoload_dirs )
    add_dirs_to_loadpath( *autoload_dirs )
    autoloads = generate_autoloads( *autoload_dirs )
    autoloads.each {|code| Object.module_eval( code )}
  end

private

  def add_dirs_to_loadpath( autoload_dirs )
    autoload_dirs.each do |dir| 
      f = File.join( @root, dir )
      $LOAD_PATH << f if File.exists?( f ) && File.directory?( f )
    end
  end

  def to_class_name( path )
    path.split('/').map {|s| camelize( s ) }.join( '::' )
  end

  def camelize( str )
    str.split( /[^a-z0-9]/i ).map{|w| w.capitalize }.join
  end

  def generate_autoloads( autoload_dirs )
    autoload_code = []
    root_segs = @root.split( '/' )
    autoload_dirs.each do |file_path|
      Dir[ File.join( @root, file_path, '/**/*.rb') ].each do |file|
        expanded = File.expand_path( file )
        autoload_code << generate_autoload_for( root_segs, expanded )
      end
    end
    autoload_code
  end

  def generate_autoload_for( root_segs, expanded_file )
    code = []
    relative_start_idx = root_segs.length == 0 ? 0 : root_segs.length + 1
    rel_file_segs = expanded_file.split( '/' )[relative_start_idx..-1] 
    # wrap autoload of file module statements
    rel_file_segs.each_with_index do |seg, i|
      if i == (rel_file_segs.length-1)
        code << "autoload :#{to_class_name( File.basename( expanded_file, '.rb' ) )}, '#{expanded_file}'"
      else
        code << "module #{to_class_name( seg )}; "
      end
    end
    code << "; end" * (rel_file_segs.length-1)
    code.join
  end

end


