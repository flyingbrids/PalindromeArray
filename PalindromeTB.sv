`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2023 03:28:13 PM
// Design Name: 
// Module Name: PalindromeTB
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
module PalindromeTB();

localparam CLOCK_FREQ   = 200; // MHz
localparam CLOCK_PERIOD = (1000ns/CLOCK_FREQ);

bit clock;
initial clock = 1'b0;
always #(CLOCK_PERIOD/2) clock = ~clock;

int file;
string testString; 
int stringCnt = 0;
int stringIndex;
logic [7:0] dataIn;
bit dataVld;
bit isTrue; 
bit dataOvfl;
bit ready , outVld;

PalindromeTest DUT(.*);

task main; 
   file = $fopen("PalindromeString.hex", "r");
   if (!file) 
      return;
   read_test_string();
endtask

task automatic read_test_string; 
  while (!$feof(file)) begin
         $fgets(testString,file);
         stringIndex = 0;
         dataVld = 0;     
         while (testString[stringIndex] ) begin
             wait(ready);
             @(posedge clock); 
               #1;
               dataIn = testString[stringIndex];
               dataVld = testString[stringIndex] != 8'ha; 
               stringIndex ++;               
         end
         @(posedge clock); 
         #1;
         dataVld = 0;
         wait(outVld);
         @(posedge clock); 
         if (dataOvfl)
            $display ("test string %d is too long!", stringCnt + 1);
         else if (isTrue)
            $display ("test string %d is Palindrome!", stringCnt + 1);
         else 
            $display ("test string %d is NOT Palindrome!", stringCnt + 1);    
         stringCnt++;    
  end  
endtask

initial begin
    main();
    $display ("test done!");  
    $stop();
end 

endmodule
