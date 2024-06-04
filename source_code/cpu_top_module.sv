`timescale 1ns / 1ps


module cpu_top_module(
input clk,//imem_read_en,
input reset,
output [31:0] data_out

    );
    
    wire next_pc_sel;
	wire [15:0]target_pc;
	wire [15:0]pc;

    
    wire [31:0] instructions;
    wire BR;    //from ALU
   // wire imem_read_en;
    
   wire BR_en;   //from decoder to alu
   wire signed [31:0] imm_32_to_alu;
   wire op_B_sel;
   wire [2:0] alu_cntrl;
   
  //ALU wires               
  wire [31:0] input_1 ;     
  wire [31:0] input_2;     
  wire [31:0] result;      
  //wire [2:0] alu_cntrl;   
  wire [31:0] input_2_mux;

//inputs to reg_file   
wire[4:0] reg_write_des_addr ;
wire[4:0] reg_read_des_addr_1;
wire[4:0] reg_read_des_addr_2;
wire[31:0] write_reg_data    ;   
wire [31:0] read_reg_data_1  ; 
wire [31:0] read_reg_data_2  ;

wire data_to_reg;

//memory read/write enable wires                           
wire mem_write_en, // imem_read_en,
write_en;

wire     [31:0]   mem_read_data;    
wire     [31:0]   mem_access_addr;                          
                                                     
assign   write_reg_data = (data_to_reg)    ?  mem_read_data :   result;                                          
assign   input_2_mux = (op_B_sel) ? imm_32_to_alu :input_2;


assign   data_out = write_reg_data;

program_counter put(
.clk(clk), 
.reset(reset),
.next_pc_sel(next_pc_sel),
.target_pc(target_pc),
.pc(pc));

decoder dec(
//.clk(clk),
.pc(pc),
.instructions(instructions),
.BR(BR),
.next_pc_sel(next_pc_sel),
.target_pc(target_pc),

.reg_write_des_addr(reg_write_des_addr), 
.reg_read_des_addr_1(reg_read_des_addr_1),
.reg_read_des_addr_2(reg_read_des_addr_2),
.reg_write_en(write_en),

.BR_en(BR_en),
.op_B_sel(op_B_sel),
.alu_cntrl(alu_cntrl),
.imm_32_to_alu(imm_32_to_alu),

.mem_write_en(mem_write_en),
.data_to_reg(data_to_reg)
);

my_reg reg_inst(
.clk(clk),
.write_en(write_en),
.reg_write_des_addr(reg_write_des_addr), 
.reg_read_des_addr_1(reg_read_des_addr_1),
.reg_read_des_addr_2(reg_read_des_addr_2),
.write_reg_data(write_reg_data),    
.read_reg_data_1(input_1),  
.read_reg_data_2(input_2)   

   ); 
 
   ALU alu_inst(
  // .clk(clk),
   .BR_en(BR_en),
   .alu_cntrl(alu_cntrl),
   .input_1(input_1),
   .input_2(input_2_mux),
   .result(result),
   .BR(BR)
//   .imm_32_to_alu(imm_32_to_alu)
  );
 
  data_mem dmem_inst(
 .clk(clk),           
 .mem_write_en(mem_write_en),    
 .mem_read_data(mem_read_data),
 .mem_access_addr(result),
 .mem_write_data(input_2)
 );
  
instruction_mem imem_inst(
.clk(clk),
.reset(reset),
.pc(pc),
.instructions(instructions)
//.read_en(imem_read_en)
);

endmodule
