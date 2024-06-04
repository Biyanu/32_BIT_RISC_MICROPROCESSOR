        `timescale 1ns / 1ps
        
        
        module instruction_mem
        #(parameter b_wdth = 32, depth  = 70)(
        input clk,reset,
        input[15:0] pc,
        output reg [31:0] instructions
       // input read_en
        );
        
        reg [b_wdth-1:0] ins_mem [0:depth-1];
        
        
        initial 
        begin   
        $readmemh("D:/KU_classes/ASIC/ASIC22/Activities/RISC_V_for_synthesis/my_ins.txt", ins_mem);
       
         end
        always @(posedge clk) begin
        if (reset) begin
           instructions <= 32'bx;
        end else begin
            instructions <= ins_mem[pc];
           end
        end
        endmodule
