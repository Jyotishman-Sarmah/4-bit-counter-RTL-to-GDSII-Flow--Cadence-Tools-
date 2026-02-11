`timescale 1ps/1ps
// Module Declaration
module counter(clk,m,rst,count);

// input & output ports declaration
input clk,m,rst;
output reg [3:0] count ;

// The Block is executed when either of positive edge of the clock 
// Both are independent events or neg edge of the rst arrives

always @(posedge clk or negedge rst) begin
    if (!rst)
    count=0;
    else if(m)  // high for up counter and low for down counter
    count = count + 1;

    else
    count = count - 1; 
end
endmodule