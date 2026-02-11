`timescale 1ps/1ps
module Counter_test;
reg clk,rst,m;
wire [1:0] count ;

initial begin
    clk=0;              // initializing clock and reset
    rst=0; #100       // all outputs are 4'b0000 from time t=0 to t=100ns
    rst=1;    // updown counting is allowed at posedge clk
end
initial 
begin
    m=0; //  condition for down counting
    #600 m=1; // condition for up counting 
    #500 m=0;
end
counter uut(clk,m,rst,count);   //Instructions of source code
always #5 clk=~clk;
initial $monitor("Time=%t rst=%b clk=%b count=%b", $time,rst,clk,count);
initial
#1400 $finish;   // finishing Simul;ation at t=1400ns

endmodule
