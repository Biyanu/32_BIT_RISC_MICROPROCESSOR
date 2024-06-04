`timescale 1ns / 1ps

module program_counter( 
input clk, reset, next_pc_sel,
input  [15:0]  target_pc,

//input BR,
output reg [15:0]  pc
  );
     always @(posedge clk)begin
     if (reset)begin
     pc <= 0;
        end 
        else if (next_pc_sel)begin
            pc <= target_pc;
         end
         else begin
         pc <= pc + 16'd4;
         end
     end
    
    
    
    
endmodule
