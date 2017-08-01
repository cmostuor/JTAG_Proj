`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:14:09 12/21/2016 
// Design Name: 
// Module Name:    BIST_reg_cell_reset 
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
module BIST_reg_cell_reset 
   (input Shift_in,
    output Shift_out,
    input Par_in,
    output Par_out,
    input Test_Log_Res,
    input Shift_DR,
    input BIST_Sh_t_clk,
    input BIST_Com_t_clk
    );
	 
	 wire Mux_t, Tr_t_TDO;
	 
	 assign Shift_out = Tr_t_TDO;
	 
	 //������������� ������ Shift/Load
	 MUX_2 Mode_shift_mux (
    .In1(Par_in), 
    .In2(Shift_in), 
    .Out(Mux_t), 
    .Sel(Shift_DR)
    );
	 
	 //������� ���������� �������� Sh_t
	 D_trigger Capture_t (
    .clk(BIST_Sh_t_clk), 
    .d(Mux_t), 
    .q(Tr_t_TDO)
    );
	 
	 //������� �������� �������� Com_t
	 D_trigger_reset Update_t (
    .d(Tr_t_TDO), 
    .q(Par_out), 
    .clk(BIST_Com_t_clk), 
    .reset(Test_Log_Res)
    );

endmodule
