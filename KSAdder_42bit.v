module sparse_42bitks(a, b, sum);
input [41:0] a, b;
output [41:0] sum;

wire [39:0] p0, g0;
wire [19:0] p1, g1;
wire [8:0] p2, g2;
wire [7:0] p3, g3;
wire [5:0] p4, g4;
wire [1:0] p5, g5;
wire c4, c8, c12, c16, c20, c24, c28, c32, c36, c40;

assign c4 = (p1[1] & g1[0]) | g1[1];
assign c8 = (p2[0] & c4) | g2[0];

assign c12 = (p3[0] & c4) | g3[0];
assign c16 = (p3[1] & c8) | g3[1];

assign c20 = (p4[0] & c4) | g4[0];
assign c24 = (p4[1] & c8) | g4[1];
assign c28 = (p4[2] & c12) | g4[2];
assign c32 = (p4[3] & c16) | g4[3];

assign c36 = (p5[0] & c4) | g5[0];
assign c40 = (p5[1] & c8) | g5[1];
genvar i;

generate for (i = 0; i < 40; i = i + 1)
begin : stage0
assign p0[i] = a[i] ^ b[i];
assign g0[i] = a[i] & b[i];
end
endgenerate

generate for (i = 0; i < 20; i = i + 1)
begin : stage1
assign p1[i] = p0[2*i+1] & p0[2*i];
assign g1[i] = (p0[2*i+1] & g0[2*i]) | g0[2*i+1];
end
endgenerate


generate for (i = 0; i < 9; i = i + 1)
begin : stage2
assign p2[i] = p1[2*i+3] & p1[2*i+2];
assign g2[i] = (p1[2*i+3] & g1[2*i+2]) | g1[2*i+3];
end
endgenerate

generate for (i = 0; i < 8; i = i + 1)
begin : stage3
assign p3[i] = p2[i+1] & p2[i];
assign g3[i] = (p2[i+1] & g2[i]) | g2[i+1];
end
endgenerate 

generate for (i = 0; i < 6; i = i + 1)
begin : stage4
assign p4[i] = p3[i+2] & p3[i];
assign g4[i] = (p3[i+2] & g3[i]) | g3[i+2];
end
endgenerate

generate for (i = 0; i < 2; i = i + 1)
begin : stage5
assign p5[i] = p4[i+4] & p4[i];
assign g5[i] = (p4[i+4] & g4[i]) | g4[i+4];
end
endgenerate

 adder4bit A0 (.x(a[3:0]), .y(b[3:0]), .ci(1'b0), .s(sum[3:0]));
 adder4bit A1 (.x(a[7:4]), .y(b[7:4]), .ci(c4), .s(sum[7:4]));
 adder4bit A2 (.x(a[11:8]), .y(b[11:8]), .ci(c8), .s(sum[11:8]));
 adder4bit A3 (.x(a[15:12]), .y(b[15:12]), .ci(c12), .s(sum[15:12]));
 adder4bit A4 (.x(a[19:16]), .y(b[19:16]), .ci(c16), .s(sum[19:16]));
 adder4bit A5 (.x(a[23:20]), .y(b[23:20]), .ci(c20), .s(sum[23:20]));
 adder4bit A6 (.x(a[27:24]), .y(b[27:24]), .ci(c24), .s(sum[27:24]));
 adder4bit A7 (.x(a[31:28]), .y(b[31:28]), .ci(c28), .s(sum[31:28]));
 adder4bit A8 (.x(a[35:32]), .y(b[35:32]), .ci(c32), .s(sum[35:32]));
 adder4bit A9 (.x(a[39:36]), .y(b[39:36]), .ci(c36), .s(sum[39:36]));
 adder2bit A10 (.x(a[41:40]), .y(b[41:40]), .ci(c40), .s(sum[41:40]));

endmodule

module adder4bit (
	input [3:0] x, y,
	input ci,
	output [3:0] s
);
wire c1, c2, c3;
fulladder F0 (x[0], y[0], ci, s[0], c1);
fulladder F1 (x[1], y[1], c1, s[1], c2);
fulladder F2 (x[2], y[2], c2, s[2], c3);
fulladder_last F3 (x[3], y[3], c3, s[3]);

endmodule

module adder2bit (
	input [1:0] x, y,
	input ci,
	output [1:0] s
);
wire t;
fulladder F4 (x[0], y[0], ci, s[0], t);
fulladder_last F5 (x[1], y[1], t, s[1]);
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