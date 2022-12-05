// ****** bootstarp ******
@256
D=A
@SP
M=D
// call Sys.init 0
// --push return-address
@Sys.init.ReturnAddress0
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
(Sys.init.ReturnAddress0)
// ****** Main ******
// function Main.fibonacci 0
// --label Main.fibonacci
(Main.fibonacci)
@0
D=A
@Main.fibonacci.End
D;JEQ
(Main.fibonacci.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Main.fibonacci.Loop
D=D-1;JNE
(Main.fibonacci.End)
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
// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
// lt                     // checks if n<2
@SP
A=M-1
D=M
A=A-1
D=D-M
@IF_TRUE0
D;JGT
D=0
@IF_FALSE0
0;JMP
(IF_TRUE0)
D=-1
(IF_FALSE0)
@SP
A=M-1
A=A-1
M=D
@SP
M=M-1
// if-goto IF_TRUE
@SP
M=M-1
A=M
D=M
@IF_TRUE
D;JNE
// goto IF_FALSE
@IF_FALSE
0;JMP
// label IF_TRUE          // if n<2, return n
(IF_TRUE)
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
// label IF_FALSE         // if n>=2, returns fib(n-2)+fib(n-1)
(IF_FALSE)
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
// push constant 2
@2
D=A
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
// call Main.fibonacci 1  // computes fib(n-2)
// --push return-address
@Main.fibonacci.ReturnAddress1
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
@6
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Main.fibonacci
@Main.fibonacci
0;JMP
// --label return-address
(Main.fibonacci.ReturnAddress1)
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
// push constant 1
@1
D=A
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
// call Main.fibonacci 1  // computes fib(n-1)
// --push return-address
@Main.fibonacci.ReturnAddress2
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
@6
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Main.fibonacci
@Main.fibonacci
0;JMP
// --label return-address
(Main.fibonacci.ReturnAddress2)
// add                    // returns fib(n-1) + fib(n-2)
@SP
A=M-1
D=M
A=A-1
M=M+D
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
// push constant 4
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Main.fibonacci 1   // computes the 4'th fibonacci element
// --push return-address
@Main.fibonacci.ReturnAddress3
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
@6
D=D-A
@ARG
M=D
// --LCL = SP
@SP
D=M
@LCL
M=D
// --goto Main.fibonacci
@Main.fibonacci
0;JMP
// --label return-address
(Main.fibonacci.ReturnAddress3)
// label WHILE
(WHILE)
// goto WHILE              // loops infinitely
@WHILE
0;JMP
