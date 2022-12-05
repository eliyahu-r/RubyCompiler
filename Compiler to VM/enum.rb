module Enum
  module Segment
    CONST = 0
    ARG = 1
    LOCAL = 2
    STATIC = 3
    THIS = 4
    THAT = 5
    POINTER = 6
    TEMP = 7
    NONE = 8
  end
  module Kind
    STATIC = 0
    FIELD = 1
    ARG = 2
    VAR = 3
    NONE = 4
  end
  module Compiles
    CLASS = 0
    CLASS_VAR_DEC = 1
    SUBROUTINE_DEC = 2
    PARAMETER_LIST = 3
    VAR_DEC = 4
    STATEMENTS = 5
    LET = 6
    IF = 7
    WHILE = 8
    RETURN = 9
    DO = 10
    EXPRESSION = 11
    TERM = 12
    SUBROUTINE_CALL = 13
    EXPRESSION_LIST = 14
  end
  module Commend
    ADD = 0
    SUB = 1
    NEG = 2
    EQ = 3
    GT = 4
    LT = 5
    AND = 6
    OR = 7
    NOT = 8
  end
end
