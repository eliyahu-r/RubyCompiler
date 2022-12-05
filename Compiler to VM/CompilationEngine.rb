require_relative 'JackTokenizer.rb'
require_relative 'SymbolTable.rb'
require_relative 'VMWriter.rb'
require_relative 'enum.rb'

class CompilationEngine
  KEYWORD_CONSTANT = /^true|false|null|this$/
  UNARY_OP = /^-|~$/
  OP = /^\+|-|\*|\/|&amp;|\||&lt;|&gt;|=$/

  def initialize(jack_path, vm_path)
    tokenizer_path = jack_path[0..-6] + "T.xml"
    @tk = JackTokenizer.new(jack_path, tokenizer_path)
    @tk.create_xml_file
    @tokenizer_file = File.open(tokenizer_path, "r")
    @current_token = ""

    @vm_writer = VMWriter.new(vm_path)

    @symbol_table = SymbolTable.new
    @label_index = -1

    @class_name = ""
    @subroutine_name = ""
  end

  def start_compile
    # advance -> drop "<tokens>"
    operate_compile(Enum::Compiles::CLASS, 1)
    advance # drop "</tokens>"
  end

  def close
    @vm_writer.close
    @tokenizer_file.close
  end

  private

  def compile_class
    advance # <keyword> class </keyword>
    advance # <identifier> class name </identifier>
    @class_name = token_value
    advance # <symbol> { </symbol>
    operate_compile(Enum::Compiles::CLASS_VAR_DEC, 1)
    operate_compile(Enum::Compiles::SUBROUTINE_DEC)
    advance # <symbol> } </symbol>
  end

  def compile_class_var_dec
    cur_token_value = token_value
    while cur_token_value == "static" or cur_token_value == "field"
      kind = Enum::Kind::NONE
      if cur_token_value == "static"
        kind = Enum::Kind::STATIC
      elsif cur_token_value == "field"
        kind = Enum::Kind::FIELD
      end
      advance # <keyword> var type </keyword>
      type = token_value
      advance # <identifier> var name </identifier>
      name = token_value
      @symbol_table.define(type, kind, name)
      advance
      while token_value == ","
        advance # <identifier> var name </identifier>
        name = token_value
        @symbol_table.define(type, kind, name)
        advance
      end
      # <symbol> ; </symbol>
      advance
      cur_token_value = token_value
    end
    @move_forward = false
  end

  def compile_subroutine_dec
    cur_token_value = token_value # <keyword> function or method or constructor</keyword>
    while cur_token_value == "function" or cur_token_value == "method" or cur_token_value == "constructor"
      @symbol_table.start_subroutine
      if cur_token_value == "method"
        @symbol_table.define("this", Enum::Kind::ARG, @class_name)
      end
      advance # <keyword> return type </keyword>  or  <identifier> class name </identifier>
      advance # <identifier> function name </identifier>
      @subroutine_name = token_value
      advance # <symbol> ( </symbol>
      operate_compile(Enum::Compiles::PARAMETER_LIST, 1)
      advance # <symbol> ) </symbol>
      advance # <symbol> { </symbol>
      operate_compile(Enum::Compiles::VAR_DEC, 1)
      write_function_dec(cur_token_value)
      operate_compile(Enum::Compiles::STATEMENTS)
      advance # <symbol> } </symbol>
      advance
      cur_token_value = token_value
    end
    @move_forward = false
  end

  def compile_parameter_list
    until token_value == ")"
      type = token_value # <keyword> parameter type </keyword> or <identifier> class name </identifier>
      advance # <identifier> parameter name </identifier>
      name = token_value
      @symbol_table.define(type, Enum::Kind::ARG, name)
      advance # <symbol> , </symbol>
      if token_value == ","
        advance
      end
    end
    @move_forward = false
  end

  def compile_var_dec
    while token_value == "var"
      advance # <keyword> var type </keyword>
      type = token_value
      advance # <identifier> var name </identifier>
      @symbol_table.define(type, Enum::Kind::VAR, token_value)
      advance
      while token_value == ","
        advance # <identifier> var name </identifier>
        @symbol_table.define(type, Enum::Kind::VAR, token_value)
        advance
      end
      # <symbol> ; </symbol>
      advance
    end
    @move_forward = false
  end

  def compile_statements
    until token_value == "}"
      @move_forward = false
      cmd = token_value
      case cmd
      when "let"
        operate_compile(Enum::Compiles::LET)
      when "if"
        operate_compile(Enum::Compiles::IF)
      when "while"
        operate_compile(Enum::Compiles::WHILE)
      when "do"
        operate_compile(Enum::Compiles::DO)
      when "return"
        operate_compile(Enum::Compiles::RETURN)
      end
      advance
    end
    @move_forward = false
  end

  def compile_let
    advance # <identifier> var name </identifier>
    var_name = token_value
    advance # <symbol> ] </symbol>  or  <symbol> = </symbol>
    exp_exist = false
    if token_value == "["
      exp_exist = true
      @vm_writer.write_push(get_segment(@symbol_table.kind_of(var_name)), @symbol_table.index_of(var_name))
      operate_compile(Enum::Compiles::EXPRESSION, 1)
      advance # <symbol> ] </symbol>
      @vm_writer.write_arithmetic(Enum::Commend::ADD) # base + offset
      advance # <symbol> = </symbol>
    end
    operate_compile(Enum::Compiles::EXPRESSION, 1)
    advance # <symbol> ; </symbol>

    if exp_exist
      @vm_writer.write_pop(Enum::Segment::TEMP, 0)
      @vm_writer.write_pop(Enum::Segment::POINTER, 1)
      @vm_writer.write_push(Enum::Segment::TEMP, 0)
      @vm_writer.write_pop(Enum::Segment::THAT, 0)
    else
      @vm_writer.write_pop(get_segment(@symbol_table.kind_of(var_name)), @symbol_table.index_of(var_name))
    end

    @move_forward = true
  end

  def compile_if
    else_label = new_label
    end_label = new_label

    advance # <symbol> ( </symbol>
    operate_compile(Enum::Compiles::EXPRESSION, 1)
    advance # <symbol> ) </symbol>

    @vm_writer.write_arithmetic(Enum::Commend::NOT)
    @vm_writer.write_if(else_label)

    advance # <symbol> { </symbol>
    operate_compile(Enum::Compiles::STATEMENTS, 1)
    advance # <symbol> } </symbol>

    @vm_writer.write_goto(end_label)
    @vm_writer.write_label(else_label)

    advance
    if token_value == "else"
      advance # <symbol> { </symbol>
      operate_compile(Enum::Compiles::STATEMENTS, 1)
      advance # <symbol> } </symbol>
      @move_forward = true
    else
      @move_forward = false
    end

    @vm_writer.write_label(end_label)
  end

  def compile_while
    continue_label = new_label
    top_label = new_label
    @vm_writer.write_label(top_label)

    advance # <symbol> ( </symbol>
    operate_compile(Enum::Compiles::EXPRESSION, 1)
    advance # <symbol> ) </symbol>

    @vm_writer.write_arithmetic(Enum::Commend::NOT)
    @vm_writer.write_if(continue_label)

    advance # <symbol> { </symbol>
    operate_compile(Enum::Compiles::STATEMENTS, 1)
    advance # <symbol> } </symbol>

    @vm_writer.write_goto(top_label)
    @vm_writer.write_label(continue_label)

    @move_forward = true
  end

  def compile_return
    advance
    if token_value == ";" # No expression
      @vm_writer.write_push(Enum::Segment::CONST, 0)
    else
      operate_compile(Enum::Compiles::EXPRESSION, -1)
      advance # <symbol> ; </symbol>
    end

    @vm_writer.write_return
    @move_forward = true
  end

  def compile_do
    operate_compile(Enum::Compiles::SUBROUTINE_CALL, 1)
    advance # <symbol> ; </symbol>
    @move_forward = true
    @vm_writer.write_pop(Enum::Segment::TEMP, 0)
  end

  def compile_expression
    operate_compile(Enum::Compiles::TERM, -1)
    advance # <symbol> op </symbol>
    while token_value.match(OP)
      op_cmd = ""
      case token_value
      when "+"
        op_cmd = "add"
      when "-"
        op_cmd = "sub"
      when "*"
        op_cmd = "call Math.multiply 2"
      when "/"
        op_cmd = "call Math.divide 2"
      when "&lt;"
        op_cmd = "lt"
      when "&gt;"
        op_cmd = "gt"
      when "="
        op_cmd = "eq"
      when "&amp;"
        op_cmd = "and"
      when "|"
        op_cmd = "or"
      end
      operate_compile(Enum::Compiles::TERM, 1)
      @vm_writer.write_command(op_cmd, "", "")
      advance
    end
    @move_forward = false
  end

  def compile_term
    if token_type == "identifier"
      identifier_name = token_value
      advance
      if token_value == "[" # varName '[' expression ']'
        @vm_writer.write_push(get_segment(@symbol_table.kind_of(identifier_name)), @symbol_table.index_of(identifier_name))
        operate_compile(Enum::Compiles::EXPRESSION, 1)
        advance # <symbol> ] </symbol>
        @vm_writer.write_arithmetic(Enum::Commend::ADD)
        @vm_writer.write_pop(Enum::Segment::POINTER, 1)
        @vm_writer.write_push(Enum::Segment::THAT, 0)
        @move_forward = true
      elsif token_value == "(" or token_value == "." # subroutineCall
        operate_compile(Enum::Compiles::SUBROUTINE_CALL, -1, identifier_name)
      else
        # varName
        @vm_writer.write_push(get_segment(@symbol_table.kind_of(identifier_name)), @symbol_table.index_of(identifier_name))
        @move_forward = false
      end
    else
      if token_type == "integerConstant" # <integerConstant> integer </integerConstant>
        @vm_writer.write_push(Enum::Segment::CONST, token_value)
        @move_forward = true
      elsif token_type == "stringConstant" # <stringConstant> string </stringConstant>
        str = token_value

        @vm_writer.write_push(Enum::Segment::CONST, str.length)
        @vm_writer.write_call("String.new", 1)

        str.each_byte do |c|
          @vm_writer.write_push(Enum::Segment::CONST, c)
          @vm_writer.write_call("String.appendChar", 2)
        end
        @move_forward = true
      elsif token_type == "keyword" and token_value.match(KEYWORD_CONSTANT) # <keyword> keyword constant </keyword>
        if token_value == "true"
          @vm_writer.write_push(Enum::Segment::CONST, 0)
          @vm_writer.write_arithmetic(Enum::Commend::NOT)
        elsif token_value == "this"
          @vm_writer.write_push(Enum::Segment::POINTER, 0)
        else
          # false or null
          @vm_writer.write_push(Enum::Segment::CONST, 0)
        end
        @move_forward = true
      elsif token_type == "symbol" and token_value == "("
        operate_compile(Enum::Compiles::EXPRESSION, 1)
        advance # <symbol> ) </symbol>
        @move_forward = true
      elsif token_type == "symbol" and token_value.match(UNARY_OP)
        unary_op = token_value
        operate_compile(Enum::Compiles::TERM, 1)
        if unary_op == "-"
          @vm_writer.write_arithmetic(Enum::Commend::NEG)
        else
          @vm_writer.write_arithmetic(Enum::Commend::NOT)
        end
      end
    end
  end

  def compile_subroutine_call(name)
    n_args = 0
    if token_value == "(" # subroutineName '(' expressionList ')'
      @vm_writer.write_push(Enum::Segment::POINTER, 0)
      n_args = operate_compile(Enum::Compiles::EXPRESSION_LIST, -1) + 1
      @vm_writer.write_call(@class_name + "." + name, n_args)
    elsif token_value == "." # (className | varName) '.' subroutineName expressionList
      advance # <identifier> subroutine name </identifier>
      subroutine_name = token_value
      type = @symbol_table.type_of(name)
      if type == ""
        subroutine_name = name + "." + subroutine_name
      else
        n_args = 1
        @vm_writer.write_push(get_segment(@symbol_table.kind_of(name)), @symbol_table.index_of(name))
        subroutine_name = @symbol_table.type_of(name) + "." + subroutine_name
      end
      n_args += operate_compile(Enum::Compiles::EXPRESSION_LIST, 1)
      @vm_writer.write_call(subroutine_name, n_args)
    else
      @move_forward = false
    end
  end

  def compile_expression_list
    n_args = 0
    advance
    if token_value == ")"
      @move_forward = true
      return n_args
    end
    n_args = 1
    operate_compile(Enum::Compiles::EXPRESSION, -1)
    advance
    while token_value == ","
      operate_compile(Enum::Compiles::EXPRESSION, 1)
      n_args += 1
      advance
    end
    @move_forward = true
    n_args
  end

  def operate_compile(compiles, change_move_forward = 0, subroutine_name = "")
    if change_move_forward == 1
      @move_forward = true
    elsif change_move_forward == -1
      @move_forward = false
    end
    advance
    case compiles
    when Enum::Compiles::CLASS
      compile_class
    when Enum::Compiles::CLASS_VAR_DEC
      compile_class_var_dec
    when Enum::Compiles::DO
      compile_do
    when Enum::Compiles::IF
      compile_if
    when Enum::Compiles::LET
      compile_let
    when Enum::Compiles::EXPRESSION
      compile_expression
    when Enum::Compiles::EXPRESSION_LIST
      compile_expression_list
    when Enum::Compiles::PARAMETER_LIST
      compile_parameter_list
    when Enum::Compiles::RETURN
      compile_return
    when Enum::Compiles::STATEMENTS
      compile_statements
    when Enum::Compiles::SUBROUTINE_CALL
      if subroutine_name == ""
        subroutine_name = token_value
        advance
      end
      compile_subroutine_call(subroutine_name)
    when Enum::Compiles::SUBROUTINE_DEC
      compile_subroutine_dec
    when Enum::Compiles::TERM
      compile_term
    when Enum::Compiles::VAR_DEC
      compile_var_dec
    when Enum::Compiles::WHILE
      compile_while
    end
  end

  def write_function_dec(keyword)
    function_name = ""
    if @class_name != "" and @subroutine_name != ""
      function_name = @class_name + "." + @subroutine_name
    end
    @vm_writer.write_function(function_name, @symbol_table.var_count(Enum::Kind::VAR))

    # METHOD and CONSTRUCTOR need to load this pointer
    if keyword == "method"
      @vm_writer.write_push(Enum::Segment::ARG, 0)
      @vm_writer.write_pop(Enum::Segment::POINTER, 0)
    elsif keyword == "constructor"
      @vm_writer.write_push(Enum::Segment::CONST, @symbol_table.var_count(Enum::Kind::FIELD))
      @vm_writer.write_call("Memory.alloc", 1)
      @vm_writer.write_pop(Enum::Segment::POINTER, 0)
    end
  end

  def get_segment(kind)
    case (kind)
    when Enum::Kind::FIELD
      Enum::Segment::THIS
    when Enum::Kind::STATIC
      Enum::Segment::STATIC
    when Enum::Kind::VAR
      Enum::Segment::LOCAL
    when Enum::Kind::ARG
      Enum::Segment::ARG
    else
      Enum::Segment::NONE
    end
  end

  def new_label
    @label_index += 1
    "LABEL_" + @label_index.to_s
  end

  def advance
    unless @move_forward
      @move_forward = true
      return @current_token
    end
    unless @tokenizer_file.eof?
      @current_token = @tokenizer_file.gets
    end
    @current_token
  end

  def token_value
    @current_token.split(">")[1].split("</")[0]
  end

  def token_type
    @current_token.split(">")[0].split("<")[1]
  end
end
