//While using different versions of Design , comment the unwanted versions of the code before simulating
// Version 1
// Structural description of 16 bit adder using 4 bit Ripple carry adder and Carry look ahead adder
//Implementation using behavioral description

 /*   module adder16bit(
        input [15:0] in1, in2,
        output [15:0] sum,
        output cout
    );
    assign {cout, sum} = in1 + in2;
        
    endmodule  */

// Version 2
// Structural description of 16-bit adder using 4 4-bit adders with behavioral description
/////////////////////////////////////////////////////////////////////////////////////////
/*
module adder16bit (
    input [15:0] in1, in2,
    output [15:0] sum,
    output cout
);
wire c1, c2, c3;
 adder4 A0 (.x(in1[3:0]), .y(in2[3:0]), .s(sum[3:0]), .cy(c1), .ci(1'b0));
 adder4 A1 (.x(in1[7:4]), .y(in2[7:4]), .s(sum[7:4]), .cy(c2), .ci(c1));
 adder4 A2 (.x(in1[11:8]), .y(in2[11:8]), .s(sum[11:8]), .cy(c3), .ci(c2));
 adder4 A3 (.x(in1[15:12]), .y(in2[15:12]), .s(sum[15:12]), .cy(cout), .ci(c3));
endmodule


module adder4 (
    input [3:0] x, y,
    input ci,
    output [3:0] s,
    output cy
);
assign {cy, s} = x + y + ci;
endmodule
*/



// Version 3
// Structural description of 16-bit adder using 4 4-bit adders
// 4-bit adders are implemented as ripple carry adder

/*

module adder16bit (
    input [15:0] in1, in2,
    output [15:0] sum,
    output cout
);
wire c1, c2, c3;
 adder4 A0 (.x(in1[3:0]), .y(in2[3:0]), .s(sum[3:0]), .cy(c1), .ci(1'b0));
 adder4 A1 (.x(in1[7:4]), .y(in2[7:4]), .s(sum[7:4]), .cy(c2), .ci(c1));
 adder4 A2 (.x(in1[11:8]), .y(in2[11:8]), .s(sum[11:8]), .cy(c3), .ci(c2));
 adder4 A3 (.x(in1[15:12]), .y(in2[15:12]), .s(sum[15:12]), .cy(cout), .ci(c3));
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



// Version 4
// Structural description of 16-bit adder using 4 4-bit adders
// 4-bit adders are implemented as carry look ahead adder

module adder16bit (
    input [15:0] in1, in2,
    output [15:0] sum,
    output cout
);
wire c1, c2, c3;
 adder4 A0 (.x(in1[3:0]), .y(in2[3:0]), .s(sum[3:0]), .cy(c1), .ci(1'b0));
 adder4 A1 (.x(in1[7:4]), .y(in2[7:4]), .s(sum[7:4]), .cy(c2), .ci(c1));
 adder4 A2 (.x(in1[11:8]), .y(in2[11:8]), .s(sum[11:8]), .cy(c3), .ci(c2));
 adder4 A3 (.x(in1[15:12]), .y(in2[15:12]), .s(sum[15:12]), .cy(cout), .ci(c3));
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
       c3 = (p2 & p1 & p0 & ci) | (p2 & p1 & g0) | (p2 & g1) | g2,
       cy = (p3 & p2 & p1 & p0 & ci)  | (p3 & p2 & p1 & g0) | (p3 & p2 & g1) | (p3 & g2) | g3;

assign s[0] = p0 ^ ci,
       s[1] = p1 ^ c1,
       s[2] = p2 ^ c2,
       s[3] = p3 ^ c3;
       

endmodule