// ****** SimpleFunction ******
// function SimpleFunction.test 2
// --label SimpleFunction.test
(SimpleFunction.test)
// --initialize local variables
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@2
D=A
@SimpleFunction.test.End
D;JEQ
(SimpleFunction.test.Loop)
@SP
A=M
M=0
@SP
M=M+1
@SimpleFunction.test.Loop
D=D-1;JNE
(SimpleFunction.test.End)
// push local 0
@0
D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// push local 1
@1
D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// add
@SP
A=M-1
D=M
A=A-1
M=M+D
@SP
M=M-1
// not
@SP
A=M-1
M=!M
// push argument 0
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// add
@SP
A=M-1
D=M
A=A-1
M=M+D
@SP
M=M-1
// push argument 1
@1
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// sub
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1
// return
// --FRAME = LCL
@LCL
D=M
// --RET = *(FRAME-5)
// RAM[13] = (LOCAL - 5)
@5
A=D-A
D=M
@13
M=D
// --*ARG = pop()
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
// --SP = ARG+1
@ARG
D=M
@SP
M=D+1
@LCL
M=M-1
A=M
D=M
@THAT
M=D
@LCL
M=M-1
A=M
D=M
@THIS
M=D
@LCL
M=M-1
A=M
D=M
@ARG
M=D
@LCL
M=M-1
A=M
D=M
@LCL
M=D
// --goto RET
@13
A=M
0;JMP
