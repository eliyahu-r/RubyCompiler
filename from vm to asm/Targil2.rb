# Eliyahu Rosenfeld 324462514
# NEVO COHEN 207962671

$counter = -1
$func_counter = -1
$answers = ""
$file_name = ""

PUSH = "@SP\nA=M\nM=D\n@SP\nM=M+1\n"
POP = "@SP\nA=M-1\nD=M\n"

def deal_label(label)
  "(#{label})\n"
end

def deal_goto(label)
  "@#{label}\n0;JMP\n"
end

def deal_if_goto(label)
  "@SP\nM=M-1\nA=M\nD=M\n@#{label}\nD;JNE\n"
end

def deal_call(func, n)
  $func_counter += 1
  ret = "// --push return-address\n@#{func}.ReturnAddress#{$func_counter}\nD=A\n#{PUSH}"
  %w[LCL ARG THIS THAT].each { |reg|
    ret += "// --push #{reg}\n@#{reg}\nD=M\n#{PUSH}"
  }
  ret += "// --ARG = SP-n-5\n@SP\nD=M\n@#{n.to_i + 5}\nD=D-A\n@ARG\nM=D\n"
  ret += "// --LCL = SP\n@SP\nD=M\n@LCL\nM=D\n"
  ret += "// --goto #{func}\n@#{func}\n0;JMP\n"
  ret + "// --label return-address\n(#{func}.ReturnAddress#{$func_counter})\n"
end

def deal_function(func, n)
  ret = "// --label #{func}\n(#{func})\n"
  ret += n != "0" ? "// --initialize local variables\n" + "@0\nD=A\n#{PUSH}" * n.to_i : ""
  ret += "@#{n}\nD=A\n@#{func}.End\nD;JEQ\n(#{func}.Loop)\n"
  ret + "@SP\nA=M\nM=0\n@SP\nM=M+1\n@#{func}.Loop\nD=D-1;JNE\n(#{func}.End)\n"
end

def deal_return
  ret = "// --FRAME = LCL\n@LCL\nD=M\n"
  ret += "// --RET = *(FRAME-5)\n// RAM[13] = (LOCAL - 5)\n@5\nA=D-A\nD=M\n@13\nM=D\n"
  ret += "// --*ARG = pop()\n@SP\nM=M-1\nA=M\nD=M\n@ARG\nA=M\nM=D\n"
  ret += "// --SP = ARG+1\n@ARG\nD=M\n@SP\nM=D+1\n"
  %w[THAT THIS ARG LCL].each { |reg|
    ret += "@LCL\nM=M-1\nA=M\nD=M\n@#{reg}\nM=D\n"
  }
  ret + "// --goto RET\n@13\nA=M\n0;JMP\n"
end

def deal_push(to_push, argument)
  case to_push
  when "constant"
    return "@#{argument}\nD=A\n#{PUSH}"
  when "local"
    return push_group_a(argument, "LCL")
  when "argument"
    return push_group_a(argument, "ARG")
  when "that"
    return push_group_a(argument, "THAT")
  when "this"
    return push_group_a(argument, "THIS")
  when "temp"
    return "@#{argument}\nD=A\n@5\nA=A+D\nD=M\n#{PUSH}"
  when "pointer"
    arg_int = Integer(argument)
    out = ""
    if arg_int == 0
      out = "@THIS\n"
    elsif arg_int == 1
      out = "@THAT\n"
    end
    if arg_int == 0 or arg_int == 1
      out += "D=M\n#{PUSH}"
    end
    return out
  when "static"
    "@#{$file_name}.#{argument}\nD=M\n#{PUSH}"
  end
end

def push_group_a(argument, type)
  "@#{argument}\nD=A\n@#{type}\nA=M+D\nD=M\n#{PUSH}"
end

def deal_pop(to_pop, argument)
  case to_pop
  when "local"
    return pop_group_a(argument, "LCL")
  when "argument"
    return pop_group_a(argument, "ARG")
  when "that"
    return pop_group_a(argument, "THAT")
  when "this"
    return pop_group_a(argument, "THIS")
  when "temp"
    return pop_group_b(argument)
  when "pointer"
    arg_int = Integer(argument)
    unless arg_int == 0 or arg_int == 1
      return ""
    end
    POP + (arg_int == 0 ? "@THIS\n" : "@THAT\n") + "M=D\n@SP\nM=M-1\n"
  when "static"
    "#{POP}@#{$file_name}.#{argument}\nM=D\n@SP\nM=M-1\n"
  end
end

def pop_group_a(argument, type)
  out = "#{POP}@#{type}\nA=M\n"
  (0..(Integer(argument) - 1)).each {
    out += "A=A+1\n"
  }
  out + "M=D\n@SP\nM=M-1\n"
end

def pop_group_b(argument)
  out = "#{POP}@5\n"
  (0..(Integer(argument) - 1)).each {
    out += "A=A+1\n"
  }
  out + "M=D\n@SP\nM=M-1\n"
end

def use_operator_binary(operator)
  "#{POP}A=A-1\nM=M#{operator}D\n@SP\nM=M-1\n"
end

def use_operator_unary(operator)
  "@SP\nA=M-1\nM=#{operator}M\n"
end

def use_operator_comparison(operator)
  $counter += 1
  ret = "#{POP}A=A-1\nD=D-M\n@IF_TRUE#{$counter}\nD;#{operator}\nD=0\n@IF_FALSE#{$counter}\n0;JMP\n"
  ret + "(IF_TRUE#{$counter})\nD=-1\n(IF_FALSE#{$counter})\n@SP\nA=M-1\nA=A-1\nM=D\n@SP\nM=M-1\n"
end

def get_command(command)
  line_format = command.split(' ')
  cmd = line_format[0]
  case cmd
  when "push"
    level = line_format[1]
    argument = line_format[2]
    return deal_push(level, argument)
  when "pop"
    level = line_format[1]
    argument = line_format[2]
    return deal_pop(level, argument)
  when "add"
    return use_operator_binary("+")
  when "sub"
    return use_operator_binary("-")
  when "neg"
    return use_operator_unary("-")
  when "eq"
    return use_operator_comparison("JEQ")
  when "gt"
    return use_operator_comparison("JLT")
  when "lt"
    return use_operator_comparison("JGT")
  when "and"
    return use_operator_binary("&")
  when "or"
    return use_operator_binary("|")
  when "not"
    use_operator_unary("!")
  when "label"
    return deal_label(line_format[1])
  when "goto"
    return deal_goto(line_format[1])
  when "if-goto"
    return deal_if_goto(line_format[1])
  when "call"
    n = line_format[2]
    return deal_call(line_format[1], n)
  when "function"
    n = line_format[2]
    return deal_function(line_format[1], n)
  when "return"
    return deal_return
  end
end

def bootstarp(write_file)
  add_to_file(write_file, "// ****** bootstarp ******\n")
  add_to_file(write_file, "@256\nD=A\n@SP\nM=D\n")
  add_to_file(write_file, "// call Sys.init 0\n" + deal_call("Sys.init", "0"))
end

def translate_file(file)
  file_read = File.open(file, "r") # Opened to read
  $file_name = file.split("/")[-1][0..-4] # Extracting the file name from the file path
  add_to_file($answers, "// ****** " + $file_name + " ******\n")
  File.foreach(file_read) { |line| # For each row in the VM file
    unless line[0..1] == "//" or line == "\n"
      cmd_list = get_command(line)
      add_to_file($answers, "// " + line + cmd_list)
    end
  }
  file_read.close
end

def deal_path(path)
  files = Dir["#{path}/**/*.vm"] # All VM files in the folder
  if files.length == 0
    puts "EEROR: Illegal path -> #{path}\n"
    return
  end
  folder_name = path.split("/")[-1] # Extracting the folder name from the path
  $answers = File.open(path + "/" + folder_name + ".asm", "w") # Create the ASM file
  if files.length > 1
    bootstarp($answers)
  end
  files.each { |file| # For each VM file in the folder (file=the file path with the file name)
    translate_file(file)
  }
end

def add_to_file(write_file, str)
  # Add text to a file
  write_file.write(str)
end

# MAIN
puts "What is the folder(s) route? (example: C:/.../...$C:/.../...)"
all_path = gets.chomp
unless all_path.empty?
  list_path = all_path.split("$")
  list_path.each { |path|
    deal_path(path)
  }
end