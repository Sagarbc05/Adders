// Test bench for 16 bit adder

module addertest;
reg [15:0] x, y;
wire [15:0] sum;
wire cout;

adder16bit DUT (x, y, sum,cout);
initial
begin
    $dumpfile ("adder.vcd");
    $dumpvars (0, addertest);
    $monitor ($time, " x = %h  y = %h  sum =%h  cout = %b", x, y, sum, cout);
    #5 x = 16'hf0a0; y = 16'h0f0a;
    #5 x = 16'hffff; y = 16'hffff;
    #5 x = 0; y = 0;
    #5 x = 12; y = 32;
    #5 $finish;
end
endmodule