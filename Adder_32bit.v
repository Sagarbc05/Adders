// Comparison of various 32 bit adder structures

// Ripple carry adder
// Spartan 6 19.308ns
// Artix 7 7.905ns 48LUTs 97 IOBs

/*
module rca32bit (
	 input [31:0] a, b,
	 output [31:0] sum,
	 output cout
);
wire c1, c2, c3, c4, c5, c6, c7;
 adder4 A0 (.x(a[3:0]), .y(b[3:0]), .s(sum[3:0]), .cy(c1), .ci(1'b0));
 adder4 A1 (.x(a[7:4]), .y(b[7:4]), .s(sum[7:4]), .cy(c2), .ci(c1));
 adder4 A2 (.x(a[11:8]), .y(b[11:8]), .s(sum[11:8]), .cy(c3), .ci(c2));
 adder4 A3 (.x(a[15:12]), .y(b[15:12]), .s(sum[15:12]), .cy(c4), .ci(c3));
 adder4 A4 (.x(a[19:16]), .y(b[19:16]), .s(sum[19:16]), .cy(c5), .ci(c4));
 adder4 A5 (.x(a[23:20]), .y(b[23:20]), .s(sum[23:20]), .cy(c6), .ci(c5));
 adder4 A6 (.x(a[27:24]), .y(b[27:24]), .s(sum[27:24]), .cy(c7), .ci(c6));
 adder4 A7 (.x(a[31:28]), .y(b[31:28]), .s(sum[31:28]), .cy(cout), .ci(c7));
endmodule


module adder4 (
	 input [3:0] x, y,
	 input ci,
	 output [3:0] s,
	 output cy
);
wire c1, c2, c3;
fulladder F0 (x[0], y[0], ci, s[0], c1);
fulladder F1 (x[1], y[1], c1, s[1], c2);
fulladder F2 (x[2], y[2], c2, s[2], c3);
fulladder F3 (x[3], y[3], c3, s[3], cy);

endmodule

module fulladder (
	 input x, y, cin,
	 output s, cout
);
wire t1,t2,t3;
xor G1 (t1, x, y);
xor G2 (s, t1, cin);
and G3 (t2, t1, cin);
and G4 (t3, x, y);
or G5 (cout, t2, t3);
endmodule
*/

//*************************************************************************
// 32 bit carry Look ahead adder
// Delay = 7.317 ns LUTs = 47  IOBs = 97  Artix 7
// Spartan 3E 36.556ns
// Spartan 6 19.308 ns
// Artix 7  7.905ns 48 LUTs and 97 IOBs

/*
module cla32bit (
	 input [31:0] a, b,
	 output [31:0] sum,
	 output cout
);
wire c1, c2, c3, c4, c5, c6, c7;
 adder4 A0 (.x(a[3:0]), .y(b[3:0]), .s(sum[3:0]), .cy(c1), .ci(1'b0));
 adder4 A1 (.x(a[7:4]), .y(b[7:4]), .s(sum[7:4]), .cy(c2), .ci(c1));
 adder4 A2 (.x(a[11:8]), .y(b[11:8]), .s(sum[11:8]), .cy(c3), .ci(c2));
 adder4 A3 (.x(a[15:12]), .y(b[15:12]), .s(sum[15:12]), .cy(c4), .ci(c3));
 adder4 A4 (.x(a[19:16]), .y(b[19:16]), .s(sum[19:16]), .cy(c5), .ci(c4));
 adder4 A5 (.x(a[23:20]), .y(b[23:20]), .s(sum[23:20]), .cy(c6), .ci(c5));
 adder4 A6 (.x(a[27:24]), .y(b[27:24]), .s(sum[27:24]), .cy(c7), .ci(c6));
 adder4 A7 (.x(a[31:28]), .y(b[31:28]), .s(sum[31:28]), .cy(cout), .ci(c7));
endmodule

module adder4 (
	 input [3:0] x, y,
	 input ci,
	 output [3:0] s,
	 output cy
);
wire p0, p1, p2, p3, g0, g1, g2, g3;
wire c1, c2, c3;
assign p0 = x[0] ^ y[0],
		 p1 = x[1] ^ y[1],
		 p2 = x[2] ^ y[2],
		 p3 = x[3] ^ y[3];

assign g0 = x[0] & y[0],
		 g1 = x[1] & y[1],
		 g2 = x[2] & y[2],
		 g3 = x[3] & y[3];

assign c1 = (p0 & ci) | g0,
		 c2 = (p1 & p0 & ci) | (p1 & g0) | g1,
		 c3 = (p2 & p1 & p0 & ci) | (p2 & p1 & g0) | (p2 & g1) | g2;		 
//assign cy = (p3 & p2 & p1 & p0 & ci)  | (p3 & p2 & p1 & g0) | (p3 & p2 & g1) | (p3 & g2) | g3;
assign cy =  (p3 & c3) | g3;
assign s[0] = p0 ^ ci,
		 s[1] = p1 ^ c1,
		 s[2] = p2 ^ c2,
		 s[3] = p3 ^ c3;
		 
endmodule
*/

// Implementation of kogge stone adder
// Spartan 3E 17.836ns
// Spartan 6  19.223ns
// Artix 7  7.772ns 49LUTs 97 IOBs

module sparse_32bitks(a, b, sum, cout);
input [31:0] a, b;
output [31:0] sum;
output cout;

wire [31:0] p0, g0;
wire [13:0] p1, g1;
wire [5:0] p2, g2;
wire [4:0] p3, g3;
wire [2:0] p4, g4;
wire c4, c8, c12, c16, c20, c24, c28;

assign c4 = (p1[1] & g1[0]) | g1[1];
assign c8 = (p2[0] & c4) | g2[0];

assign c12 = (p3[0] & c4) | g3[0];
assign c16 = (p3[1] & c8) | g3[1];

assign c20 = (p4[0] & c4) | g4[0];
assign c24 = (p4[1] & c8) | g4[1];
assign c28 = (p4[2] & c12) | g4[2];
genvar i;

generate for (i = 0; i < 28; i = i + 1)
begin : stage0
assign p0[i] = a[i] ^ b[i];
assign g0[i] = a[i] & b[i];
end
endgenerate

generate for (i = 0; i < 14; i = i + 1)
begin : stage1
assign p1[i] = p0[2*i+1] & p0[2*i];
assign g1[i] = (p0[2*i+1] & g0[2*i]) | g0[2*i+1];
end
endgenerate


generate for (i = 0; i < 6; i = i + 1)
begin : stage2
assign p2[i] = p1[2*i+3] & p1[2*i+2];
assign g2[i] = (p1[2*i+3] & g1[2*i+2]) | g1[2*i+3];
end
endgenerate

generate for (i = 0; i < 5; i = i + 1)
begin : stage3
assign p3[i] = p2[i+1] & p2[i];
assign g3[i] = (p2[i+1] & g2[i]) | g2[i+1];
end
endgenerate 

generate for (i = 0; i < 3; i = i + 1)
begin : stage4
assign p4[i] = p3[i+2] & p3[i];
assign g4[i] = (p3[i+2] & g3[i]) | g3[i+2];
end
endgenerate

 adder4 A0 (.x(a[3:0]), .y(b[3:0]), .ci(1'b0), .s(sum[3:0]));
 adder4 A1 (.x(a[7:4]), .y(b[7:4]), .ci(c4), .s(sum[7:4]));
 adder4 A2 (.x(a[11:8]), .y(b[11:8]), .ci(c8), .s(sum[11:8]));
 adder4 A3 (.x(a[15:12]), .y(b[15:12]), .ci(c12), .s(sum[15:12]));
 adder4 A4 (.x(a[19:16]), .y(b[19:16]), .ci(c16), .s(sum[19:16]));
 adder4 A5 (.x(a[23:20]), .y(b[23:20]), .ci(c20), .s(sum[23:20]));
 adder4 A6 (.x(a[27:24]), .y(b[27:24]), .ci(c24), .s(sum[27:24]));
 adder4_last A7 (.x(a[31:28]), .y(b[31:28]), .ci(c28), .s(sum[31:28]), .cy(cout));

endmodule

module adder4 (
	 input [3:0] x, y,
	 input ci,
	 output [3:0] s,
	 output cy
);
wire c1, c2, c3;
fulladder F0 (x[0], y[0], ci, s[0], c1);
fulladder F1 (x[1], y[1], c1, s[1], c2);
fulladder F2 (x[2], y[2], c2, s[2], c3);
fulladder_last F3 (x[3], y[3], c3, s[3]);

endmodule

module adder4_last (
	 input [3:0] x, y,
	 input ci,
	 output [3:0] s,
	 output cy
);
wire c1, c2, c3;
fulladder F0 (x[0], y[0], ci, s[0], c1);
fulladder F1 (x[1], y[1], c1, s[1], c2);
fulladder F2 (x[2], y[2], c2, s[2], c3);
fulladder F3 (x[3], y[3], c3, s[3], cy);
endmodule

module fulladder (
	 input x, y, cin,
	 output s, cout
);
wire t1,t2,t3;
xor G1 (t1, x, y);
xor G2 (s, t1, cin);
and G3 (t2, t1, cin);
and G4 (t3, x, y);
or G5 (cout, t2, t3);
endmodule

module fulladder_last (
	 input x, y, cin,
	 output s
);
wire t1,t2,t3;
xor G1 (t1, x, y);
xor G2 (s, t1, cin);
endmodule
