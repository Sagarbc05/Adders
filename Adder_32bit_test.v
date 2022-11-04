/*
module Adder_32bit_test;
reg [31:0] a, b;
wire [31:0] sum;
wire cout;

sparse_32bitks DUT (a, b, sum, cout);
initial begin
    a = 32'h98a635e1;
    b = 32'h45623199;

    #2 $display(" a = %h b = %h sum = %h cout = %b", a, b, sum, cout);
    #2 $display("c4 = %b c8 = %b c12 = %b c16 = %b", DUT.c4, DUT.c8, DUT.c12, DUT.c16);
    $display ("c20 = %b c24 = %b c28 = %b", DUT.c20, DUT.c24, DUT.c28);
end
endmodule
*/

module Adder_32bit_test;
reg [41:0] a, b;
wire [41:0] sum;

sparse_42bitks DUT (a, b, sum);
initial begin
    a = 42'h3ffffffffff;
    b = 42'h00000000001;

    #2 $display(" a = %h b = %h sum = %h", a, b, sum);
    #2 $display("c4 = %b c8 = %b c12 = %b c16 = %b", DUT.c4, DUT.c8, DUT.c12, DUT.c16);
    $display ("c20 = %b c24 = %b c28 = %b c32 = %b c36 = %b c40 = %b", DUT.c20, DUT.c24, DUT.c28, DUT.c32, DUT.c36, DUT.c40);
end
endmodule