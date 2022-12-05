class JackTokenizer
  KEYWORD = /^(class|constructor|method|function|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/
  SYMBOL = /^([{}()\[\].,;+\-*\/&|<>=~])$/
  INTEGER_CONSTANT = /^\d+$/
  STRING_CONSTANT = /^"[^"\n\r]*"$/
  IDENTIFIER = /^[a-zA-Z]+[a-zA-Z_0-9]*$/

  def initialize(file_path, xml_path)
    @jack_file = File.readlines(file_path)
    @vm_file = File.open(xml_path, "w")
    @line_number = 0
    @current_line = @jack_file[0].gsub(/(\/\/.*)|\r|\n/, "")
    @tokens = []
  end

  def create_xml_file
    while @line_number < @jack_file.size
      if @current_line.include?("/*")
        deal_comments
        advance_line
      else
        split_line(@current_line)
        advance_line
      end
    end

    write_tokens
    @vm_file.close
  end

  private

  def deal_comments
    start_index = @current_line.index("/*")
    end_index = @current_line.index("*/")
    if start_index == 0
      result = ""
    else
      result = @current_line[0..(start_index - 1)] + " "
    end

    while end_index == NIL
      advance_line
      end_index = @current_line.index("*/")
    end

    result += @current_line[(end_index + 2)..]
    if result.include?("/*")
      @current_line = result
      deal_comments
    else
      split_line(result)
    end
  end

  def split_line(string)
    i = 0
    line_tokens = []
    strings = string.split(/(")/)
    while i < strings.length
      if strings[i] == '"'
        if strings[i + 1] != '"'
          line_tokens << '"' + strings[i + 1] + '"'
          i += 1
        end
        i += 1
      else
        line_tokens << strings[i].split(/\t| |([{}()\[\].,;+\-*\/&|<>=~])/)
      end
      i += 1
    end
    @tokens += line_tokens.flatten.select { |s| !s.empty? }
  end

  def write_tokens
    @vm_file.write("<tokens>\n")
    @tokens.each do |current_token|
      @vm_file.write("<#{token_type(current_token)}>")
      if current_token.include?('"')
        @vm_file.write(current_token[1..-2])
      elsif current_token == "<"
        @vm_file.write("&lt;")
      elsif current_token == ">"
        @vm_file.write("&gt;")
      elsif current_token == "&"
        @vm_file.write("&amp;")
      else
        @vm_file.write(current_token)
      end
      @vm_file.write("</#{token_type(current_token)}>\n")
    end
    @vm_file.write("</tokens>")
  end

  def token_type(current_token)
    if current_token.match(KEYWORD)
      "keyword"
    elsif current_token.match(SYMBOL)
      "symbol"
    elsif current_token.match(INTEGER_CONSTANT)
      "integerConstant"
    elsif current_token.match(STRING_CONSTANT)
      "stringConstant"
    elsif current_token.match(IDENTIFIER)
      "identifier"
    else
      "error"
    end
  end

  def advance_line
    @line_number += 1
    if @line_number < @jack_file.size
      @current_line = @jack_file[@line_number].gsub(/(\/\/.*)|\r|\n/, "")
    end
  end
end