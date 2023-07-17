# PalindromeArray
detect if the input array is Palindrome

To open this project, you need Vivado 2021.2 or above.
Steps to re-create the project on Vivado:
1. Download the repo and open Vivado
2. On Tcl Console tpye **cd** followed by the path of the folder where the tcl file is. (use '/' in the folder path and the path should not exceed 100 characters)
3. On the Tcl Console type **source Palindrome.tcl** This will automatically re-create the project. 

Tips for source control of Vivado Project:
1. Always create source files or IPs outside the local folder. 
2. Use **write_project_tcl** tcl command to generate the tcl files after changes have been made and save the tcl file outside the local folder
