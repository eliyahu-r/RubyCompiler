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
// push constant 4000	// test THIS and THAT context save
@4000
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 0
@SP
A=M-1
D=M
@THIS
M=D
@SP
M=M-1
// push constant 5000
@5000
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 1
@SP
A=M-1
D=M
@THAT
M=D
@SP
M=M-1
// call Sys.main 0
// --push return-address
@Sys.main.ReturnAddress9
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
// --goto Sys.main
@Sys.main
0;JMP
// --label return-address
(Sys.main.ReturnAddress9)
// pop temp 1
@SP
A=M-1
D=M
@5
A=A+1
M=D
@SP
M=M-1
// label LOOP
(LOOP)
// goto LOOP
@LOOP
0;JMP
// function Sys.main 5
// --label Sys.main
(Sys.main)
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
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@Sys.main.End
D;JEQ
(Sys.main.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.main.Loop
D=D-1;JNE
(Sys.main.End)
// push constant 4001
@4001
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 0
@SP
A=M-1
D=M
@THIS
M=D
@SP
M=M-1
// push constant 5001
@5001
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 1
@SP
A=M-1
D=M
@THAT
M=D
@SP
M=M-1
// push constant 200
@200
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop local 1
@SP
A=M-1
D=M
@LCL
A=M
A=A+1
M=D
@SP
M=M-1
// push constant 40
@40
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop local 2
@SP
A=M-1
D=M
@LCL
A=M
A=A+1
A=A+1
M=D
@SP
M=M-1
// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop local 3
@SP
A=M-1
D=M
@LCL
A=M
A=A+1
A=A+1
A=A+1
M=D
@SP
M=M-1
// push constant 123
@123
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Sys.add12 1
// --push return-address
@Sys.add12.ReturnAddress10
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
// --goto Sys.add12
@Sys.add12
0;JMP
// --label return-address
(Sys.add12.ReturnAddress10)
// pop temp 0
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
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
// push local 2
@2
D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// push local 3
@3
D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
// push local 4
@4
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
// add
@SP
A=M-1
D=M
A=A-1
M=M+D
@SP
M=M-1
// add
@SP
A=M-1
D=M
A=A-1
M=M+D
@SP
M=M-1
// add
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
// function Sys.add12 0
// --label Sys.add12
(Sys.add12)
@0
D=A
@Sys.add12.End
D;JEQ
(Sys.add12.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.add12.Loop
D=D-1;JNE
(Sys.add12.End)
// push constant 4002
@4002
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 0
@SP
A=M-1
D=M
@THIS
M=D
@SP
M=M-1
// push constant 5002
@5002
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 1
@SP
A=M-1
D=M
@THAT
M=D
@SP
M=M-1
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
// push constant 12
@12
D=A
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
