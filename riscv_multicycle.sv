`timescale 1ns / 1ps

/***************************************************************************
* Filename: riscv_multicycle.sv
*
* Module: riscv_multicycle
*
* Author: Daniel Nybo
* Class: ECEN 323, Section 3, Winter 2021
* Date: 2/20/2021
*
* Description: control module for control/datapath logic to interface with instructino memory and Data memory
*
****************************************************************************/
`include "riscv_datapath_constants.sv"

//module for control logic for interface with instruction/data memroy in the RISC-V
//datapath.
module riscv_multicycle#(parameter [31:0] INITIAL_PC = INIT_PC_VALUE)(
    output logic[31:0] PC,              //the Program Counter
    output logic[31:0] dAddress,        //address for data memory
    output logic[31:0] dWriteData,      //data to write into data memory
    output logic MemRead,               //Control signal indicating memory read
    output logic MemWrite,              //Control signal indicating memory write
    output logic [31:0] WriteBackData,  //Data being written to registers( for debug )
    input wire logic clk,               //global clock
    input wire logic rst,               //synchronous reset
    input wire logic[31:0] instruction, //instruction data from instruction memory
    input wire logic[31:0] dReadData    //data read from data memory
    );
    //state constants for instruction execution state machine
    localparam IF_ST = 3'b000;
    localparam ID_ST = 3'b001;
    localparam EX_ST = 3'b010;
    localparam MEM_ST = 3'b011;
    localparam WB_ST = 3'b100;
    
    // The current state and next state of the state machine
    logic [1:0] state, next_state;
    
    //logic signals to go into the simple datapath unit
    
    
    
    //instantiation of the stimple datapath 
    riscv_simpledatapath myDataPath(
        PC,              //program counter                         // used
        Zero,            //ALU Zero indicator                           
        dAddress,        //Address for data memory                 //used
        dWriteData,      //Data to write into memory               //used
        WriteBackData,   //Write Back data going back into the reg file
        clk,             //global clock                             //used
        rst,             //synchronous reset                        //used
        instruction,     //instruction data from instruction memory //used
        PCSrc,           //choose which signal to update PC
        ALUSrc,          //choose which signal to pass to alu
        RegWrite,        //Write data in the reg file
        MemtoReg,        //register file input multiplexer
        dReadData,       //Data read from data memory               //used
        ALUCtrl,         //indicates which operation that the alu should perform
        loadPC           //load pc logic signal tells whether or not to load pc
    );
    
   
    //5 state, state machine for sequencing through the 5 steps of executing an instruction
    //always ff logic for state machine, next state updated here
    always_ff@(posedge clk)
    begin
        if (rst)
            state = IF_ST;
        else
            state = next_state;
    end
    
    //state logic in alwyas comb block. sequentially move through each state given each instruction
    always_comb
    begin
        //default assignment
        next_state = state;
        //case statement for each state to overide the default
        case(state)
            //states will sequentially iterate and loop back to Instruction Fetch State
            //Instruction Fetch    
            IF_ST:
                
                next_state = ID_ST;
            //Instruction Decode
            ID_ST:
                next_state = EX_ST;
            //Execution state
            EX_ST:
                next_state = MEM_ST;
            //memory access state
            MEM_ST:
                next_state = WB_ST;
            //write back state
            WB_ST:
            begin
                loadPC = HIGH;
                next_state = IF_ST;
            end
        endcase
    end
	
	//output forming logic for state machine
	 
    
endmodule
