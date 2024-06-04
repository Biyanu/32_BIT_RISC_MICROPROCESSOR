    `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Biynu zerom
// Create Date: 02/17/2022 12:04:26 PM
// Design Name: Biynu zerom
// Module Name: data_mem
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


module data_mem(
                input clk, 
                input mem_write_en, 
             
                input[31:0] mem_access_addr,    
                input[31:0] mem_write_data, 
                output [31:0] mem_read_data

                 );
                 
        reg [31:0] data_mem_array [0:1023] ;
        
        wire [15:0] mem_addr = mem_access_addr[15:0];
        initial begin
        // CONSIDER READING SAVED DATA FROM FILES HERE
        $readmemh("D:/KU_classes/ASIC/ASIC22/Activities/RISC_V_modelsim_simulation/mem_data.vmh", data_mem_array);
          
        end
        

            always @(posedge clk)
                     begin
                        if (mem_write_en)begin
                            data_mem_array[mem_addr] <= mem_write_data;
                            
                     end
                     else begin
                      data_mem_array[mem_addr] <= 32'b0;
                     end
                     end
            assign mem_read_data =  data_mem_array[mem_addr];    
endmodule
