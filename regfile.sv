`timescale 1ns / 1ps

/***************************************************************************
* 
* Module: Register File for RISC-V proccessor
*
* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 1/27/2021
*
* Description: This module contains the logic/code required for the register file in the RISC-V proccessor
*
****************************************************************************/

//module declaragin for creating reg file for RISC-V proccessor. it will be a 3 port register with 2 reads and 1 write
module regfile(
    output logic[31:0] regReadDataA,
    output logic[31:0] regReadDataB,
    input wire logic clk,
    input wire logic [4:0] regAddrA,
    input wire logic [4:0] regAddrB,
    input wire logic [4:0] regAddrWrite,
    input wire logic [31:0] regWriteData,
    input wire logic regWrite
    );
    
    localparam ZERO = 0;
    
    //multi-dimensional logic array (32 words, 32 bits each)
    logic[31:0] register[31:0];
    
    // Initialize the 32 words
    integer i;
    initial
      for (i=0;i<32;i=i+1)
        register[i] = ZERO;
    
    //here is the always_ff block for the logic needed to create the reg file
    always_ff@(posedge clk) 
    begin
        regReadDataA <= register[regAddrA];
        regReadDataB <= register[regAddrB];
        if (regWrite && (regAddrWrite != ZERO)) 
        begin
            register[regAddrWrite] <= (regWriteData);
            if (regAddrA == regAddrWrite)
                regReadDataA <= regWriteData;
            if (regAddrB == regAddrWrite)
                regReadDataB <= regWriteData;
        end
    end
    
        
endmodule
