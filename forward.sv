`timescale 1ns / 1ps

module forward(
    input bypassAfromMEM,
    input bypassAfromALUinWB,
    input bypassAfromLWinWB,
    input bypassBfromMEM,
    input bypassBfromALUinWB,
    input bypassBfromLWinWB,
    input [31:0] IDEXA,
    input [31:0] IDEXB,
    input [31:0] MEMWBValue,
    input [31:0] EXMEMALUOut,
    output [31:0] Ain,
    output [31:0] Bin
    );
    
   // TODO assign Ain and Bin 
      assign Ain = (bypassAfromMEM) ? EXMEMALUOut :
                (bypassAfromALUinWB) ? MEMWBValue :
                (bypassAfromLWinWB) ? MEMWBValue :
                IDEXA;

   assign Bin = (bypassBfromMEM) ? EXMEMALUOut :
                (bypassBfromALUinWB) ? MEMWBValue :
                (bypassBfromLWinWB) ? MEMWBValue :
                IDEXB;


endmodule
