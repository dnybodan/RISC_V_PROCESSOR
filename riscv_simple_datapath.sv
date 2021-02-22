`timescale 1ns / 1ps

/***************************************************************************
* Filename: riscv_simple_datapath.sv

* Module: riscv_simple_datapath
*
* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 2/17/2021
*
* Description: this is the datapath module for creating simple datapath logic for the risc v processor
*
****************************************************************************/
`include "riscv_datapath_constants.sv"

//module declaration for risc-v datapath logic
module riscv_simple_datapath #(parameter [31:0] INITIAL_PC = INIT_PC_VALUE) (
    output logic[31:0] PC,              //program counter
    output logic Zero,                  //ALU Zero indicator
    output logic[31:0] dAddress,        //Address for data memory
    output logic[31:0] dWriteData,      //Data to write into memory
    output logic[31:0] WriteBackData,   //Write Back data going back into the reg file
    input wire logic clk,               //global clock
    input wire logic rst,               //synchronous reset
    input wire logic[31:0] instruction, //instruction data from instruction memory
    input wire logic PCSrc,             //choose which signal to update PC
    input wire logic ALUSrc,            //choose which signal to pass to alu
    input wire logic RegWrite,          //Write data in the reg file
    input wire logic MemtoReg,          //register file input multiplexer
    input logic[31:0] dReadData,       //Data read from data memory
    input wire logic[3:0] ALUCtrl,      //indicates which operation that the alu should perform
    input wire logic loadPC             //update the pc with a new value
    );
    
    //logic wires for connecting up the register file to the datapath
    logic[31:0] regReadDataA;
    logic[31:0] regReadDataB;
    logic [4:0] regAddrA;
    logic [4:0] regAddrB;
    logic [4:0] regAddrWrite;
    logic [31:0] regWriteData;
    
    //declaration of immediate generation wires
    logic [31:0] immediate_I;
    logic [31:0] immediate_S;
    
    //logic wires for instantiating the ALU
    logic[31:0] op1;
    logic[31:0] ALUsrc_signal_out;
    
    //aluResult wire
    logic[31:0] result;
    
    //logic wire for branch target signal
    logic[31:0] branch_offset;
    
    //op code logic wire
    logic[6:0] opCode;
    
    //instantiation of the register file
    regfile myRegFile(
        regReadDataA,   //written to the first operand in the ALU
        regReadDataB,   
        clk,            //written by the top module
        regAddrA,       //written to by the instruciton in top module
        regAddrB,       //written to by instruction in top module
        regAddrWrite,   //written to by instruction in top module
        regWriteData,
        RegWrite        //written to by regwrite signal in top module
    );
    
    //instantiation of the ALU
    alu myALU(
        result,             //checked to see if zero and wired to memory interface
        regReadDataA,       //wired up the register file
        ALUsrc_signal_out,  //wired to the immediate value or the reg read data b  
        ALUCtrl             //wired up from the top level control signal
    );
    
    //logic for interfacing with the data memory
    assign dAddress = result;
    assign dWriteData = regReadDataB;
    
    //assign the alu src signal based on this mux with the ALUSrc as the control
    always_comb
    begin
        if(opCode == S_TYPE)
        begin
            ALUsrc_signal_out = (ALUSrc ? immediate_S : regReadDataB);
        end
        else if (opCode == SB_TYPE)
        begin
           ALUsrc_signal_out = (ALUSrc ? immediate_S : regReadDataB);  
        end
        else
        begin
            ALUsrc_signal_out = (ALUSrc ? immediate_I : regReadDataB);           
        end
    end
    
    //wire up the instruction to the approriate register read/write address values in the register file
    assign regAddrA = instruction[19:15];
    assign regAddrB = instruction[24:20];
    assign regAddrWrite = instruction[11:7];
    assign opCode = instruction[6:0];
    
    //sign extended immediate value generation
    assign immediate_I = 32'(signed'(instruction[31:20]));
    assign immediate_S = {{20{instruction[31]}},{instruction[31:25]},{instruction[11:7]}};  // check these to see if they have the right bits
    
    //logic for shifting branch offset and adding it to current PC value
    assign branch_offset = (immediate_S);
        
    //determine if the result of ALU is zero and then attach to top level module
    always_comb
    begin
        if(result == ZERO)
            Zero = ONE;
        else
            Zero = ZERO;
    end
    
    //write back data logic
    assign regWriteData = (MemtoReg ? dReadData : result);
    assign WriteBackData = regWriteData;
    
    //when the rst signal is asserted, reset the PC to the default value
    always_ff@(posedge clk)
    begin
        //reset if reset is asserted
        if(rst)
            PC <= INITIAL_PC;
        //if load PC is high then update program counter
        else if (loadPC)
        begin
            if(PCSrc)
                PC <= PC + branch_offset;  //take pc to the branch offset
            else
                PC <= PC + DEFAULT_PC_UPDATE;  // update pc to next instruction
        end     
    end
        
endmodule
