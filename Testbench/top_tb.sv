`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2022 07:30:34 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb(

);
  reg clk, reset;//imem_read_en;

  wire [31:0] data_out;
 cpu_top_module   uut(.clk(clk), .reset(reset), .data_out(data_out) );



always #5 clk =~clk;
//always  #100 reset =~reset;

 initial begin
 clk = 1;
// imem_read_en = 0;
 
 reset =1;
 #10;
  reset =0;
//  imem_read_en = 0;
 #10;
// imem_read_en = 1;
 #150;
$finish;
 end

 
    
endmodule
