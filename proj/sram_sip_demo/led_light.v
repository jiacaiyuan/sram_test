`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/13 08:50:14
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led(
led_0,
led_1,
led_2,
led_3
    );
output led_0,led_1,led_2,led_3;
reg led_0,led_1,led_2,led_3;
always@(*)
begin
    led_0=1'b1;
    led_1=1'b1;
    led_2=1'b1;
    led_3=1'b1;
end
endmodule
