//NAME: Shahbaz Hassan Khan Malik
//DATE: 11/21/2021
//LAB 8

`timescale 1ns/100ps
module alu(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
parameter WIDTH = 8;
output reg [WIDTH - 1:0] ALU_OUT; 
output reg CF, OF, SF, ZF; //carry flag, overflow flag, negative flag, zero flag
input [3:0] OPCODE;
input [WIDTH - 1:0] A, B;
input CLK, EN, OE;
reg[WIDTH-1:0] temp;
reg[WIDTH-1 :0] B_TwoComp;

localparam ADD_function = 4'b0010;
localparam SUB_function = 4'b0011;
localparam AND_function = 4'b0100;
localparam OR_function = 4'b0101;
localparam XOR_function = 4'b0110;
localparam NOT_function = 4'b0111;


//if EN=0, maintain previous state
//if OE=0, ALU_OUT=8'bZ

always@(OE, temp, posedge CLK) ALU_OUT = (OE) ? temp:8'bz;

always@(posedge CLK) begin

if(EN) begin
case(OPCODE)

ADD_function: begin
temp = A+B;

//CARRY
if (A+B>2**WIDTH-1) CF=1; 
else 
CF=0;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;

//OF
if(A[WIDTH-1]==1 && B[WIDTH-1]==1 && temp[WIDTH-1]==0) OF=1; // if pos+pos=neg
else if (A[WIDTH-1]==0 && B[WIDTH-1]==0 && temp[WIDTH-1]==1) OF=1; //if neg+neg=pos
else OF=0;


end

SUB_function: begin
B_TwoComp = ~B + 1;
temp = A+B_TwoComp;

//CARRY
if (A<B) CF=1; 
else 
CF=0;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;

//OF
if(A[WIDTH-1]==1 && B[WIDTH-1]==1 && temp[WIDTH-1]==0) OF=1; // if pos+pos=neg
else if (A[WIDTH-1]==0 && B[WIDTH-1]==0 && temp[WIDTH-1]==1) OF=1; //if neg+neg=pos
else OF=0;

end

AND_function: begin
temp = A&B;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;


end

OR_function: begin
temp = A|B;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;


end

XOR_function: begin
temp = A^B;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;


end

NOT_function: begin
temp = ~A;

//SIGNED
if (temp[WIDTH-1]==1) SF=1; //if MSB is 1, it is a signed operator
else
SF=0;

//ZERO
if (temp==0) ZF=1;
else ZF=0;


end

default: temp=1'bx;
endcase
end
end
endmodule
