//NAME: SHAHBAZ HASSAN KHAN MALIK
//LAB 7

`timescale 1ns/100ps
`define MONITOR_STR_1 " MONITOR: %d: CLK=%d, EN=%d, OE=%d, OPCODE=%b, A=%b, B=%b, A=%d, B=%d | ALU_OUT=%b, ALU_OUT=%d, CF=%d, OF=%d, SF=%d, ZF=%d"
`define MONITOR_STR_2 " MONITOR: %d: CLK=%d, EN=%d, OE=%d, OPCODE=%b, A=%b, A=%d | ALU_OUT=%b, ALU_OUT=%d, CF=%d, OF=%d, SF=%d, ZF=%d"
`define signedmode

module alu_tb();

parameter WIDTH = 8; 
wire CF, OF, SF, ZF;
reg[3:0] OPCODE;
reg CLK, EN, OE; 

`ifdef signedmode begin
reg signed[WIDTH-1:0] ALU_OUT;
reg signed[WIDTH-1:0] A,B;
end

`else begin

wire [WIDTH - 1:0] ALU_OUT; 
reg [WIDTH - 1:0] A, B;
end

`endif

alu #(WIDTH) myALU(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);

initial begin 
CLK=1'b0;
forever #25 CLK=~CLK;
end

initial
begin
$vcdpluson;
$monitor(`MONITOR_STR_1, $time, CLK, EN, OE, OPCODE, A, B, A, B, ALU_OUT, ALU_OUT, CF, OF, SF, ZF);
end

initial 
begin

`ifdef signedmode 
#75 $display("------------------SIGNED NUMBERS------------------");
`else
#75 $display("------------------UNSIGNED NUMBERS------------------");
`endif

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0010; 
#75 $monitoron; $display("-----TESTING ADD-----"); A=8'd2; B=8'd3;
#150 $display("->TESTING ZERO FLAG"); A=8'd0; B=8'd0;
#75 $display("->TESTING CARRY & NEGATIVE FLAG"); A=8'd200; B=8'd200;
#125 $display("->TESTING OVERFLOW FLAG"); A=8'd80; B=8'd80; 

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0011; 
#75 $monitoron; $display("-----TESTING SUB-----"); A=8'd4; B=8'd2;
#150 $display("->TESTING ZERO FLAG"); A=8'd0; B=8'd0;
#90 $display("->TESTING CARRY & NEGATIVE FLAG #1"); A=8'd100; B=8'd50;
#150 $display("->TESTING CARRY & NEGATIVE FLAG #2"); A=8'd10; B=8'd150;
#75 $display("->TESTING OVERFLOW FLAG #1"); A=8'd90; B=8'd40; 
#75 $display("->TESTING OVERFLOW FLAG #2"); A=8'd40; B=8'd90; 
#150 $display("->TESTING ZERO FLAG"); A=8'd40; B=8'd40; 

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0100;
#150 $monitoron; $display("-----TESTING AND-----"); A=8'd4; B=8'd2;
#150 $monitoron; $display("->TESTING ZERO FLAG"); A=8'd0; B=8'd0;
#150 $monitoron; $display("->TESTING NEGATIVE FLAG"); A=8'd200; B=8'd255;

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0101;
#150 $monitoron; $display("-----TESTING OR-----"); A=8'd4; B=8'd2;
#150 $monitoron; $display("->TESTING ZERO FLAG"); A=8'd0; B=8'd0;
#150 $monitoron; $display("->TESTING NEGATIVE FLAG"); A=8'd200; B=8'd255;

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0110;
#150 $monitoron; $display("-----TESTING XOR-----"); A=8'd4; B=8'd2;
#150 $monitoron; $display("->TESTING ZERO FLAG"); A=8'd255; B=8'd255;
#150 $monitoron; $display("->TESTING NEGATIVE FLAG"); A=8'b01010101; B=8'b10101010;

#75 $monitoroff;
#75 OE=1; EN=1; OPCODE=4'b0111;
#150 $monitoron;  $display("-----TESTING NOT [IGNORE B value]-----"); A=8'd4; 
#150 $monitoron; $display("->TESTING ZERO FLAG"); A=8'd255; 
#150 $monitoron; $display("->TESTING NEGATIVE FLAG"); A=8'b0; 

#150 $monitoroff; 
#150 OE = 0;
#150 $display("-------TESTING OE = 0-------");
#150 $monitoron; OPCODE=4'b0111; A=8'd12;
#150 $display("-------SETTING OE = 1 --------"); OE=1;
#150 $display("-------TESTING EN = 0-------"); EN = 0;
#150 A=8'd1;
#150 $finish;

end

endmodule
