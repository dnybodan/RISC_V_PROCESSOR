`timescale 1ns / 1ps
/***************************************************************************
* 
* Module: alu
*
* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 1.20.2021
*
* Description: this is the alu, arithmetic logic unit. It will perform basic arithmetic 
* operations at the binary level in the RISK-V processor
*
****************************************************************************/
`include "riscv_alu_constants.sv"

/*
In this module there will be input operands and one output which will be determined based on the operation specified
inputs
op1-operand 1
op2-operand 2
alu_op-indicates which operation to perform
and ouput
results-ALU Result
*/
module alu(
output logic [31:0] result,
input wire logic[31:0] op1,
input wire logic[31:0] op2,
input wire logic[3:0] alu_op
    );

//this block will hold the case logic to determine which operation has been input to the circuit
always_comb
begin
    case(alu_op)
        AND_OP:
            result = op1 & op2;
        OR_OP:
            result = op1 | op2;
        ADD_OP:
            result = op1 + op2;
        SUB_OP:
            result = op1 - op2;
        LESS_THAN_OP:
            result = $signed(op1) < $signed(op2);
        X_OR_OP:
            result = op1 ^ op2;
        default:
            result = op1 + op2;
    endcase
end
    
    
endmodule
