`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:41 12/23/2016 
// Design Name: 
// Module Name:    BIST_block 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BIST_block(
    input [3:0] BIST_from_logic_Y,
    output [3:0] BIST_to_logic_X,
	 output BIST_to_logic_res,
	 output BIST_to_logic_clk,
    input clk_50MHz,
    input BIST_clk_en,
    input BIST_res,
    input [15:0] From_BIST_reg,
    output [15:0] To_BIST_reg
    );

wire BIST_clk;			//�������� ������ ��� ������ BIST
assign BIST_clk = BIST_clk_en & clk_50MHz; 
	
wire [7:0] Counter;		//�� ��������
wire End_flag;				//���� ��������� ��������� �� �������� ������
wire log_clk_en;			//���� ��� ������� ������� ��������� �� �������� ������
wire Error_f;				//���� ������ �� �����������
wire log_res_f;			//���� ������ ������
wire [4:0] BIST_code;	//�� BIST_FSM

wire Counter_incr_en;	//���������� ���������� ��������
wire Counter_res;			//����� �������� � 0
wire Mem_we;				//���������� ������ � ������
wire Mem_res;				//����� ������ � ��������� ���������
wire Bufer_we;				//���������� ������ � �����
wire Bufer_res;			//����� ����������� ������ � 0
wire Set_error;			//��������� �� ������ BIST ��������� �� ������
wire Out_buf_res;			//������� ���������� ��������� ������ � 11110000 00000000
wire En_Log_clk;			//������ ���������� ������������ ������
wire [15:0] To_BIST_bufer;			//���������� ������ � ������ BIST
wire [7:0] Comand_for_decoder;	//���������� ������ � �������� ������
wire [7:0] Out_data;		//����� ������ � ������

// ������ BIST-FSM
BIST_FSM BIST_FSM_M (
    .BIST_clk(BIST_clk), 
    .res(BIST_res), 		
    .Mode_sel(From_BIST_reg[15:12]), 
    .Counter_in(Counter), 
    .end_flag(End_flag), 
	 .log_clk_en(log_clk_en),                 
    .error_flag(Error_f),
	 .log_res_flag(log_res_f),	 
    .BIST_CODE(BIST_code)		
    );
	 

// ������ �������� BIST-FSM
BIST_FSM_Decoder BIST_FSM_Decoder_M (
    .BIST_CODE(BIST_code), 
    .BIST_clk(BIST_clk), 
    .BIST_res(BIST_res), 
    .Counter_incr_en(Counter_incr_en), 
    .Counter_res(Counter_res), 
    .Mem_we(Mem_we), 
    .Mem_res(Mem_res), 
    .Bufer_we(Bufer_we), 
    .Bufer_res(Bufer_res), 
    .Set_error(Set_error), 
    .Out_buf_res(Out_buf_res), 
    .En_Log_clk(En_Log_clk),
	 .Log_RES(BIST_to_logic_res)
    );

// ������ ��������
BIST_counter BIST_counter_M (
    .clk(BIST_clk), 
    .res(Counter_res), 
    .Incr_en(Counter_incr_en), 
    .Counter(Counter) 
    );
	 
// ������ ������
BIST_mem BIST_mem_M (
    .clk(BIST_clk), 
    .we(Mem_we), 
    .res(Mem_res), 
    .adr(Counter), 
    .in(From_BIST_reg), 
    .out(To_BIST_bufer)     
    );

// ���������� ����� ��� ������ � ������
BIST_bufer BIST_bufer_M (
    .clk(BIST_clk), 
    .Bufer_write_en(Bufer_we), 
    .Bufer_res(Bufer_res), 
    .In(To_BIST_bufer),  
    .Out_com(Comand_for_decoder), 			
    .Out_data(Out_data)			
    );

// ������� ������
BIST_Comand_Decoder BIST_Comand_Decoder_M (
    .Comand_in(Comand_for_decoder), 
    .To_Logic_X(BIST_to_logic_X), 
    .End_flag(End_flag),    
    .log_clk_en(log_clk_en),
	 .log_res_flag(log_res_f)
    );

// ����������
BIST_Comparator BIST_Comparator_M (
    .From_Logic_Y(BIST_from_logic_Y), 
    .From_data_buf(Out_data[3:0]), 
    .Error_flag(Error_f) 
    );

// �������� ����� BIST
BIST_out_bufer BIST_out_bufer_M (
    .Err_code(Out_data), 
    .clk(BIST_clk), 
    .Output(To_BIST_reg), 
    .Err_flag(Set_error), 
    .res(Out_buf_res)
    );


//������������� ��������� ������� ������
For_logic_clk For_logic_clk_M (
    .clk(clk_50MHz), 
    .clk_en(En_Log_clk), 
    .To_logic_clk(BIST_to_logic_clk)
    );

endmodule
