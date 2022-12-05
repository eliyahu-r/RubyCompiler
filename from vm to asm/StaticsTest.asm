// ****** bootstarp ******
@256
D=A
@SP
M=D
// call Sys.init 0
// --push return-address
@Sys.init.ReturnAddress4
D=A
@SP
A=M
M=D
@SP
M=M+1
// --push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THIS
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THAT
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// --ARG = SP-n-5
@SP
D=M
@5
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Sys.init
@Sys.init
0;JMP
// --label return-address
(Sys.init.ReturnAddress4)
// ****** Class1 ******
// function Class1.set 0
// --label Class1.set
(Class1.set)
@0
D=A
@Class1.set.End
D;JEQ
(Class1.set.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Class1.set.Loop
D=D-1;JNE
(Class1.set.End)
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
// pop static 0
@SP
A=M-1
D=M
@Class1.0
M=D
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
// pop static 1
@SP
A=M-1
D=M
@Class1.1
M=D
@SP
M=M-1
// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
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
// function Class1.get 0
// --label Class1.get
(Class1.get)
@0
D=A
@Class1.get.End
D;JEQ
(Class1.get.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Class1.get.Loop
D=D-1;JNE
(Class1.get.End)
// push static 0
@Class1.0
D=M
@SP
A=M
M=D
@SP
M=M+1
// push static 1
@Class1.1
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
// ****** Class2 ******
// function Class2.set 0
// --label Class2.set
(Class2.set)
@0
D=A
@Class2.set.End
D;JEQ
(Class2.set.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Class2.set.Loop
D=D-1;JNE
(Class2.set.End)
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
// pop static 0
@SP
A=M-1
D=M
@Class2.0
M=D
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
// pop static 1
@SP
A=M-1
D=M
@Class2.1
M=D
@SP
M=M-1
// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
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
// function Class2.get 0
// --label Class2.get
(Class2.get)
@0
D=A
@Class2.get.End
D;JEQ
(Class2.get.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Class2.get.Loop
D=D-1;JNE
(Class2.get.End)
// push static 0
@Class2.0
D=M
@SP
A=M
M=D
@SP
M=M+1
// push static 1
@Class2.1
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
// ****** Sys ******
// function Sys.init 0
// --label Sys.init
(Sys.init)
@0
D=A
@Sys.init.End
D;JEQ
(Sys.init.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.init.Loop
D=D-1;JNE
(Sys.init.End)
// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// push constant 8
@8
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Class1.set 2
// --push return-address
@Class1.set.ReturnAddress5
D=A
@SP
A=M
M=D
@SP
M=M+1
// --push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THIS
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THAT
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// --ARG = SP-n-5
@SP
D=M
@7
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Class1.set
@Class1.set
0;JMP
// --label return-address
(Class1.set.ReturnAddress5)
// pop temp 0 // Dumps the return value
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
// push constant 23
@23
D=A
@SP
A=M
M=D
@SP
M=M+1
// push constant 15
@15
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Class2.set 2
// --push return-address
@Class2.set.ReturnAddress6
D=A
@SP
A=M
M=D
@SP
M=M+1
// --push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THIS
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THAT
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// --ARG = SP-n-5
@SP
D=M
@7
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Class2.set
@Class2.set
0;JMP
// --label return-address
(Class2.set.ReturnAddress6)
// pop temp 0 // Dumps the return value
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
// call Class1.get 0
// --push return-address
@Class1.get.ReturnAddress7
D=A
@SP
A=M
M=D
@SP
M=M+1
// --push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THIS
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THAT
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// --ARG = SP-n-5
@SP
D=M
@5
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Class1.get
@Class1.get
0;JMP
// --label return-address
(Class1.get.ReturnAddress7)
// call Class2.get 0
// --push return-address
@Class2.get.ReturnAddress8
D=A
@SP
A=M
M=D
@SP
M=M+1
// --push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THIS
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
// --push THAT
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
// --ARG = SP-n-5
@SP
D=M
@5
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Class2.get
@Class2.get
0;JMP
// --label return-address
(Class2.get.ReturnAddress8)
// label WHILE
(WHILE)
// goto WHILE
@WHILE
0;JMP
