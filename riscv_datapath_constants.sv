`timescale 1ns / 1ps

/***************************************************************************
* Filename: riscv_datapath_constants.sv

* Module: constants only 
*
* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 2/17/2021
*
* Description: this file contains constants related to the riscv simple data path
****************************************************************************/


`ifndef RISCV_DATAPATH_CONSTANTS
`define RISCV_DATAPATH_CONSTANTS

localparam[31:0] INIT_PC_VALUE = 32'h00400000;
localparam[31:0] DEFAULT_PC_UPDATE = 32'h00000004; 
localparam ONE = 2'b01;
localparam ZERO = 2'b00;
localparam S_TYPE = 7'b0100011;
localparam SB_TYPE = 7'b1100011;

`endif // RISCV_DATAPATH_CONSTANTS