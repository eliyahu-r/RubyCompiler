require_relative 'CompilationEngine.rb'

def get_all_jack_files(path)
  if path[-5..-1] == ".jack"
    [path]
  else
    Dir["#{path}/**/*.jack"]
  end
end

def compile_jack_file(jack_path)
  vm_path = jack_path[0..-5] + "vm"
  compile_engine = CompilationEngine.new(jack_path, vm_path)
  compile_engine.start_compile
  compile_engine.close
  puts "\tCompile successfully: " + jack_path.split("/")[-1]
end

# cd C:\Users\nevoc\RubymineProjects\untitled\Tar5
# jack_complier C:/Users/nevoc/RubymineProjects/nand2tetris/tools/testOS
path = ARGV[0] # "C:/Users/nevoc/RubymineProjects/nand2tetris/tools/testOS
unless path.empty?
  all_jack_files = get_all_jack_files(path)
  puts all_jack_files.size.to_s + " jack file/s were found"
  all_jack_files.each { |jack_file|
    compile_jack_file(jack_file)
  }
end