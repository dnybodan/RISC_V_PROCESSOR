`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: RISC-V alu constants file

* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 1.20.2021
*
*
* Description: this file will hold the constants needed for the alu, including operation constants
*
****************************************************************************/
`ifndef RISCV_ALU_CONSTANTS
`define RISCV_ALU_CONSTANTS

localparam[3:0] AND_OP = 4'b0000;
localparam[3:0] OR_OP = 4'b0001; 
localparam[3:0] ADD_OP = 4'b0010;
localparam[3:0] SUB_OP = 4'b0011; 
localparam[3:0] LESS_THAN_OP = 4'b0111;
localparam[3:0] X_OR_OP = 4'b1101; 


`endif // RISCV_ALU_CONSTANTS
