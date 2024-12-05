`timescale 1ns / 1ps

module decode(
    input clk,
    input stall,
    input IDEXAfromWB,
    input IDEXBfromWB,
    input [31:0] IFIDIR,
    input [31:0] MEMWBValue,
    output reg [31:0] IDEXIR,
    output reg [31:0] IDEXA,
    output reg [31:0] IDEXB,
    output reg branchTaken,
    output reg [31:0] branchPCOffset
    );
    
     initial begin
        IDEXIR = no_op;
        IDEXA = no_op;
        IDEXB = no_op;
     end
     
     wire [5:0] IFIDop;
     assign IFIDop = IFIDIR[31:26];
    
    `include "parameters.sv"
    always @(posedge clk)begin
        if (stall) 
              begin// the first three pipeline stages stall if there is a load hazard or branch stall
                  //inject NOPs
                  IDEXIR <= no_op;
                  IDEXA <= 32'b0;
                  IDEXB <= 32'b0;
                 
                 
              end
         else begin
            //ID stage, with input from the WB stage
            IDEXIR <= IFIDIR;
            if (~IDEXAfromWB)
              IDEXA <= CPU.Regs[IFIDIR[25:21]]; 
            else
              IDEXA <= MEMWBValue;
            if (~IDEXBfromWB)
              IDEXB <= CPU.Regs[IFIDIR[20:16]]; 
            else
              IDEXB <= MEMWBValue;
            
            if (IFIDop == BEQINIT) begin
                if (branchTaken) begin
                    // Set the value of R[rt] to 1
                    CPU.Regs[IFIDIR[20:16]] <= 1; 
                end
            end


         end
    end      
    
    always @(*) begin 
      //set the bran3ranchPCOffset
        if (IFIDop == BEQINIT) begin
            branchPCOffset = {{16{IFIDIR[15]}}, IFIDIR[15:0]} << 2; 
        end else begin
            branchPCOffset = 32'b0; 
        end

    end

endmodule
