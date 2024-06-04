`timescale 1ns / 1ps

module my_reg(
input clk, write_en,

input [4:0] reg_write_des_addr,
input [4:0] reg_read_des_addr_1, 
input [4:0] reg_read_des_addr_2,
input [31:0] write_reg_data,
output [31:0] read_reg_data_1,
output [31:0] read_reg_data_2

    );
   reg [31:0] reg_file [31:0];           
    integer i; 
   initial begin                         
  for (i  = 0; i <32; i= i +1)
   
  reg_file[i] = 32'd0;
   end
   always @ ( posedge clk)
    begin
   if (write_en)
   begin
   reg_file[reg_write_des_addr] <= write_reg_data;
   end
   else
   begin
    reg_file[reg_write_des_addr] <= 32'd0;
   end
   end
   assign read_reg_data_1 = reg_file[reg_read_des_addr_1];
   assign read_reg_data_2 = reg_file[reg_read_des_addr_2];
endmodule
