    `timescale 1ns / 1ps
  
    module ALU(
   // input clk,
    input  signed  [31:0] input_1,         // the first operand
    input  signed  [31:0] input_2,        //second operand
    output reg signed  [31:0] result,
//    input [31:0] imm_32_to_alu,
    input reg     [2:0] alu_cntrl,       //alu control sufficient no. of bit to represent the instructions for this assignment
    output reg BR,
    input   BR_en                   
    );
  
       always @ (*)
        begin
    
//        result = (alu_cntrl == 3'b000) ? input_1 + input_2   :             //ADD or ADDI based on the control signal
//                 (alu_cntrl == 3'b001) ? input_1  - input_2  :             //SUB
//                 (alu_cntrl == 3'b010) ? input_1  ^ input_2  :             //XOR or XORI are  performed here based on the control signal
//                 (alu_cntrl == 3'b011) ? input_1  < input_2  :            //SLT
//                                            32'b0;                        //Default   
                                            
         if  (alu_cntrl == 3'b000)begin
         result = input_1 + input_2 ;
         end
         else if  (alu_cntrl == 3'b001)begin
          result =  input_1  - input_2 ;
          end
          else if  (alu_cntrl == 3'b010) begin
           result = input_1  ^ input_2;
           
           end 
           else if  (alu_cntrl == 3'b011) begin
           result = input_1  < input_2;
           end
           else begin
           
          result =  32'b0;
         end                                                                    
                    
//         BR = (BR_en==0)? 1'b0:((alu_cntrl== 3'b100) && (input_1 < input_2))? 1'b1:           //BLT
//                             ((alu_cntrl== 3'b101) && (input_1 >= input_2))? 1'b1:1'b0;     //BGE
                             
          if (BR_en==0)      begin
            BR = 1'b0;
            end
            else if ((alu_cntrl== 3'b100) && (input_1 < input_2)) begin
            
             BR = 1'b1;
            end
        else if ((alu_cntrl== 3'b101) && (input_1 >= input_2)) begin
        
           BR = 1'b1;
          end           
       else begin
       BR = 1'b0;
       end                      

        end
    endmodule
