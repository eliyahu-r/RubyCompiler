require_relative 'enum.rb'

class VMWriter
  def initialize(vm_path)
    @segment = { Enum::Segment::CONST => "constant", Enum::Segment::ARG => "argument", Enum::Segment::LOCAL => "local",
                 Enum::Segment::STATIC => "static", Enum::Segment::THIS => "this", Enum::Segment::THAT => "that",
                 Enum::Segment::POINTER => "pointer", Enum::Segment::TEMP => "temp" }
    @command = { Enum::Commend::ADD => "add", Enum::Commend::SUB => "sub", Enum::Commend::NEG => "neg",
                 Enum::Commend::EQ => "eq", Enum::Commend::GT => "gt", Enum::Commend::LT => "lt",
                 Enum::Commend::AND => "and", Enum::Commend::OR => "or", Enum::Commend::NOT => "not" }

    @vm_file = File.open(vm_path, "w")
  end

  def write_push(segment, index)
    write_command("push", @segment[segment], index.to_s)
  end

  def write_pop(segment, index)
    write_command("pop", @segment[segment], index.to_s)
  end

  def write_arithmetic(command)
    write_command(@command[command], "", "")
  end

  def write_label(label)
    write_command("label", label, "")
  end

  def write_goto(label)
    write_command("goto", label, "")
  end

  def write_if(label)
    write_command("if-goto", label, "")
  end

  def write_call(name, n_args)
    write_command("call", name, n_args.to_s)
  end

  def write_function(name, n_locals)
    write_command("function", name, n_locals.to_s)
  end

  def write_return
    write_command("return", "", "")
  end

  def close
    @vm_file.close
  end

  def write_command(command_line, arg1, arg2)
    @vm_file.write(command_line + " " + arg1 + " " + arg2 + "\n")
  end
end
