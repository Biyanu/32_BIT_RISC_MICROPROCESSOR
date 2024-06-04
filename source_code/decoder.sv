    `timescale 1ns / 1ps
    
    module decoder #(
      parameter ADDRR_BITS = 16
    )(
    input BR,                           //clock signal
    //Fetched information                
    input [31:0] instructions,           // instruction from instruction emory
    input [ADDRR_BITS-1:0] pc,  
    
    //outputs of fetch
    output reg next_pc_sel,     
    output [ADDRR_BITS-1:0] target_pc,
    
    // signals to register file
    output [4:0] reg_write_des_addr,      // reg 1, reg 2 and the destination register respectively
    output [4:0] reg_read_des_addr_1,     // register write enable
    output [4:0] reg_read_des_addr_2,
    output reg   reg_write_en,
    
   
   
    
    //signals that go to the ALU
    output reg    BR_en,                       //branch signal that goes to ALU
    output [31:0]  imm_32_to_alu,    
    output  reg [2:0]  alu_cntrl,            // here we use only 3-bit signal to control the alu                   
                                            // because we only have 8 instructions for this assignment 
    //signal that go to memory
    output reg mem_write_en, op_B_sel, data_to_reg
                   
     );
      wire[6:0] opcode, func_7;   
      wire[2:0] func_3;            
     
     
  
    localparam [6:0] R_TYPE   = 7'b0110011,   //we only need few of these instruction for this assignment             
                     I_TYPE   = 7'b0010011,   //This can be extended to accomodate all instruction of the RISC-v ISA 
                     STORE    = 7'b0100011,                                                                          
                     LOAD     = 7'b0000011,                                                                          
                     BRANCH   = 7'b1100011;                                                                          
      
      wire [11:0] org_imm;
      wire [31:0] imm_32;
      //reg  [2:0]  alu_cntrl;
      wire [11:0] s_imm_orig;
      //wire [4:0]  s_imm_lsb;
      wire [31:0] s_imm_32;
      wire [31:0] sb_imm_32;
      wire [12:0] sb_imm_orig;
        
     //Register values are assigned here
     assign reg_read_des_addr_1 = instructions[19:15];
     assign reg_read_des_addr_2 = instructions[24:20];
     assign reg_write_des_addr  = instructions[11:7]; 
     
     //instruction decoding 
     assign opcode = instructions[6:0];
     assign func_7 = instructions[31:25];
     assign func_3 = instructions[14:12];
    
     // immediate signals are extracted here
     assign org_imm     =    instructions[31:20];
     assign imm_32      =    {{20{org_imm[11]}},org_imm};                  // I-TYPE IMMEDIATE SIGN EXTENDED
     assign s_imm_orig  =    {instructions[31:25],instructions[11:7]};     // S-TYPE IMMEDIATE     
     assign s_imm_32     =    {{20{s_imm_orig[11],s_imm_orig}}};            // S-TYPE IMMEDIATE SIGN EXTENDED sign extended
     assign sb_imm_orig =    {{instructions[31]},                          // SB-TYPE IMMEDIATE
                             {instructions[7]}, 
                             {instructions[30:25]}, 
                             {instructions[11:8]}, 1'b0};   
                           
     assign sb_imm_32  =     {{19{sb_imm_orig[12], sb_imm_orig}}};  
   
     assign imm_32_to_alu =  (opcode == 7'b0010011) ? imm_32:       //I-type
                             (opcode == 7'b0000011) ? imm_32:       //Load        
                             (opcode == 7'b0100011) ? s_imm_32:     //S-type    
                             (opcode == 7'b1100011) ? sb_imm_32:    //Branches  
                              0;                                    //Default    

    
     assign target_pc =      (opcode == 7'b1100011)? (pc + sb_imm_32[15:0]):0;    // branch instruction
                                                                                  //the remaining instructions may be considered in future
 
           always @ (*) begin
                  casex(opcode)
            
    7'b0110011:  begin    
                  next_pc_sel <= 0;
                  BR_en<=0;
                  mem_write_en<=0;
                  data_to_reg<=0;
                  op_B_sel<=0;
                  //wb_sel = 0;
                  reg_write_en<=1;
                  
                  if((func_7 == 7'b0000000) &&( func_3 == 3'b000)) begin 
                  alu_cntrl <= 3'b000;
                      end
                  else if ((func_7 == 7'b0100000 )&& (func_3 == 3'b000)) begin
                  
                  alu_cntrl <= 3'b001;
                             end 
                   else if (func_7 == 7'b0000000 && func_3 == 3'b100) begin
                   
                  alu_cntrl <= 3'b010; 
              
                  
                  end
                  else if (func_7 == 7'b0000000 && func_3 == 3'b010)begin
                            alu_cntrl <= 3'b011; 
                  end
                  else begin
                            alu_cntrl <= 3'b000; //default addition
                  end

                  end  
                                          
    7'b0010011:   begin   // I-type
                                              
                   next_pc_sel <= 0;
                   BR_en <= 0;
                   mem_write_en <= 0;
                   reg_write_en <= 1;
                   op_B_sel <= 1;
                   data_to_reg <= 0;
                   
                   if (func_3 == 3'b100) begin
                             alu_cntrl <= 3'b000; 
                   end
                   else if (func_3 == 3'b101) begin
                             alu_cntrl <= 3'b001; 
                   end
                   else begin
                     alu_cntrl <= 3'b000;
                   end
                   end
                    
                       
    7'b0000011: begin               //Load type
                    next_pc_sel <= 0;
                    BR_en = 0;
                    mem_write_en <= 0;
                    op_B_sel <= 1;
                    reg_write_en <= 1;
                    alu_cntrl <= 3'b000;
                    data_to_reg <= 1;
           end
           
    7'b0100011: begin    //Store type
            
                    next_pc_sel <= 0;
                    BR_en = 0;
                    mem_write_en <= 1;
                    op_B_sel <= 1;
                    reg_write_en <= 0;
                    data_to_reg <= 0;
                    alu_cntrl <= 3'b000;
            end
                     
    7'b1100011: begin    //branch type
     
                   
                    mem_write_en <= 0;
                    op_B_sel <= 0;
                    reg_write_en <= 0;
                    reg_write_en <= 0;
                    data_to_reg  <=0;
                          
                          
                    if(BR) begin
                       next_pc_sel <= 1;
                    end
                    else begin
                    next_pc_sel <= 0;
                    end
                    
                    if(func_3 == 3'b100) begin
                    alu_cntrl <= 3'b100;
                    end
                    
                    else if (func_3 == 3'b101) begin
                    alu_cntrl <= 3'b100;
                    end
                    
                    else
                    begin
                    alu_cntrl <= 3'b000;
                    end
     
      end
      default: begin
                   next_pc_sel <= 0;
                  BR_en <= 0;
                  mem_write_en <= 0;
                  data_to_reg <= 0;
                  op_B_sel <= 0;
                  //wb_sel = 0;
                  reg_write_en <= 1;
      
      end
                    
          endcase 
        end              
    endmodule
