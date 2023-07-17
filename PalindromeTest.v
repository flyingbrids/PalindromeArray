`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2023 03:00:58 PM
// Design Name: 
// Module Name: PalindromeTest
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
module PalindromeTest # ( parameter MAX_DATA = 128 )
(
       input wire clock,
       input wire [7:0] dataIn,
       input wire dataVld,
       output reg isTrue,
       output reg outVld,
       output reg dataOvfl = 0,
       output wire ready
    );

reg [7:0] dataArry [MAX_DATA-1:0];
reg [$clog2(MAX_DATA)-1:0] inputPointer = 0;
reg [$clog2(MAX_DATA)-1:0] iterationCnt = 0;
wire isEqual;
reg reset;
reg dataVld_d;

always @ (posedge clock) begin
      if (reset) begin
         inputPointer <= 0;
         dataOvfl <= 0;
      end else if (dataVld & ~dataOvfl ) begin
         inputPointer <= inputPointer + 1;
         dataArry[inputPointer] <= dataIn;   
         dataOvfl <= &inputPointer;
      end 
end 

always @ (posedge clock) 
    dataVld_d <= dataVld;
 
assign isEqual = dataArry[iterationCnt] == dataArry[inputPointer-1-iterationCnt];

reg [1:0] ProcessState = 0;
always @ (posedge clock) begin
           case (ProcessState) 
           3'd0: begin
                reset <= 0;
                iterationCnt <= 0;
                isTrue <= 0;
                outVld <= dataOvfl;
                if (!dataVld & dataVld_d & !dataOvfl)
                   if (inputPointer > 1)
                       ProcessState <= 1;
                   else 
                       ProcessState <= 2;
           end
           3'd1: begin
                iterationCnt <= iterationCnt + 1;
                isTrue <= (iterationCnt == inputPointer[$clog2(MAX_DATA)-1:1]-1) & isEqual;
                outVld <= (iterationCnt == inputPointer[$clog2(MAX_DATA)-1:1]-1) | ~isEqual;
                if ((iterationCnt == inputPointer[$clog2(MAX_DATA)-1:1]-1) | ~isEqual) begin
                    ProcessState <= 0;
                    reset <= 1;
                end 
           end
           3'd2: begin
                isTrue <= 1;
                outVld <= 1;    
                ProcessState <= 0;
                reset <= 1;          
           end 
           default: begin
                isTrue <= 0;
                outVld <= 0;  
                ProcessState <= 0;
                reset <= 1;          
           end                   
           endcase
end       

assign ready = (ProcessState == 0) & ~reset;
    
endmodule
