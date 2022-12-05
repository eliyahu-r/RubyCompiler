require_relative 'OneSymbol.rb'
require_relative 'enum.rb'

class SymbolTable
  def initialize
    @class_symbols = {} # <String, Symbol> for STATIC, FIELD
    @subroutine_symbols = {} # <String, Symbol> for ARG, VAR
    @indices = { Enum::Kind::ARG => 0, Enum::Kind::FIELD => 0, Enum::Kind::STATIC => 0, Enum::Kind::VAR => 0 } # <KIND, Integer>
  end

  def start_subroutine
    @subroutine_symbols.clear
    @indices[Enum::Kind::VAR] = 0
    @indices[Enum::Kind::ARG] = 0
  end

  def define(type, kind, name)
    if kind == Enum::Kind::ARG or kind == Enum::Kind::VAR
      index = @indices[kind]
      @subroutine_symbols[name] = OneSymbol.new(type, kind, index)
      @indices[kind] = @indices[kind] + 1
    elsif kind == Enum::Kind::STATIC or kind == Enum::Kind::FIELD
      index = @indices[kind]
      @class_symbols[name] = OneSymbol.new(type, kind, index)
      @indices[kind] = @indices[kind] + 1
    end
  end

  def var_count(kind)
    @indices[kind]
  end

  def kind_of(name)
    symbol = look_up(name)
    if symbol != NIL and symbol.is_a? OneSymbol
      return symbol.get_kind
    end
    Enum::Kind::NONE
  end

  def type_of(name)
    symbol = look_up(name)
    if symbol != NIL and symbol.is_a? OneSymbol
      return symbol.get_type
    end
    ""
  end

  def index_of(name)
    symbol = look_up(name)
    if symbol != NIL and symbol.is_a? OneSymbol
      return symbol.get_index
    end
    -1
  end

  def look_up(name)
    if @class_symbols[name] != NIL
      return @class_symbols[name]
    elsif @subroutine_symbols[name] != NIL
      return @subroutine_symbols[name]
    end
    NIL
  end
end
