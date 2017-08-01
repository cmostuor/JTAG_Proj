`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:44 12/21/2016 
// Design Name: 
// Module Name:    BIST_FSM 
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
module BIST_FSM
	(input BIST_clk,
	 input res,
	 input [3:0] Mode_sel,
	 input [7:0] Counter_in,
	 input end_flag,
	 input log_clk_en,
	 input error_flag,
	 input log_res_flag,
	 output reg [4:0] BIST_CODE);
 
reg [4:0] state = 0; // ��������� �������� ��� ���������/������

/* ����������� ��������� ��������*/
 
parameter [4:0] state0			= 0, 
					 state1			= 1, 
					 state1_1		= 2,
					 state1_2		= 3,			 
					 state2			= 4,
					 state2_1		= 5,
					 state2_2		= 6,					 
					 state2_3		= 7,
					 logic_res 		= 8,
					 state2_4		= 9,					 
					 state2_5		= 10,					 
					 state2_6		= 11,					 
					 state2_7		= 12,					 
					 state2_8		= 13,					 
					 state2_9		= 14,					 
					 state3			= 15,
					 state4			= 16;
	  
always @(posedge BIST_clk or posedge res) begin
 
if (res) begin
	state = state0;
end
else begin
 
/*����������� ���������� ��������� ��������*/
 
      case(state)

      state0:								//��������� �����, �������� � ���� �� Update
				if(Mode_sel == 4'b0000 || Mode_sel == 4'b0001 || Mode_sel == 4'b0010)
					state = state1;
				else if(Mode_sel == 4'b0100)
					state = state2;
				else if(Mode_sel == 4'b0011)
					state = state3;
				else
					state = state4;
 
      state1:								//����� �������� � ������ ��������
            if(Counter_in == 255)
					state = state4;
				else
					state = state1_1;
		
		state1_1:
					state = state1_2; 
					
		state1_2:
					state = state4; 
		
		//����� ������������
		state2:								//����� ��������
					state = state2_1; 	
		
		state2_1:							//������ � ����� �� ������
					state = state2_2; 	
		
		state2_2:							//���� ���� ��� ������������ �������� �� ������ �������� ������
					state = state2_3; 		
		
		state2_3:							//��������� ��� �������	
				if(end_flag)				//���� ��������� ��������� ��� ������, �� ���������������� ������� BIST - �� ������ ����� 11110000_00000000
					state = state3;		
				else if(log_res_flag)   //���� ������� ������������
					state = logic_res;
				else if(log_clk_en)		//���� ������� ����������� X, ������ �� ���������
					state = state2_5;
				else
					state = state3;
		
		logic_res:							//����� �������� �����
				state = state2_4;
		
		state2_4:							//������������� �������� � ������� � ����. �������
				state = state2_1;
					
		state2_5:							//��������� ������������ ������
				state = state2_6;
		
		state2_6:							//���� 1 ���� ������������ ������� �� ������ ������
				state = state2_7;			
		
		state2_7:							//�������� ����� ������
				if(error_flag)				
					state = state2_8;
				else 
					state = state2_4;		//��� �� - ��������� � ����. �������	
		
		state2_8:							//���������� ��� ������
				state = state2_9;
				
		state2_9:							//C��������� ������� ������ � ��������� � �������� - �� ������ ��������� �� ������		
				state = state4;
				
		state3:								//����� ������ �������� BIST � ��������� ���������
					state = state4; 
					
		state4:								//����� ��������
					state = state4;

	
		default: state = state0;
 
      endcase
end 
end
 
/*��������� ������ ��������� ��������*/
 
always @(state)
 
begin
 
      case (state)
 
      state0: 
					begin
					BIST_CODE = 0;
					$display($time,":state0");
					end
 
      state1: 
					begin
					BIST_CODE = 1;
					$display($time,":state1");
					end	
					
      state1_1: 
					begin
					BIST_CODE = 2;
					$display($time,":state1_1");
					end		
		
		state1_2: 
					begin
					BIST_CODE = 3;
					$display($time,":state1_2");
					end	
		
		state2: 
					begin
					BIST_CODE = 4;
					$display($time,":state2");
					end			
		state2_1: 
					begin
					BIST_CODE = 5;
					$display($time,":state2_1");
					end			
		state2_2: 
					begin
					BIST_CODE = 6;
					$display($time,":state2_2");
					end	
		state2_3: 
					begin
					BIST_CODE = 7;
					$display($time,":state2_3");
					end	
		
		logic_res: 
					begin
					BIST_CODE = 8;
					$display($time,":logic_res");
					end			
		
		state2_4: 
					begin
					BIST_CODE = 9;
					$display($time,":state2_4");
					end			
		state2_5: 
					begin
					BIST_CODE = 10;
					$display($time,":state2_5");
					end	
		state2_6: 
					begin
					BIST_CODE = 11;
					$display($time,":state2_6");
					end
		state2_7: 
					begin
					BIST_CODE = 12;
					$display($time,":state2_7");
					end
		state2_8: 
					begin
					BIST_CODE = 13;
					$display($time,":state2_8");
					end
		state2_9: 
					begin
					BIST_CODE = 14;
					$display($time,":state2_9");
					end
		
		state3: 
					begin
					BIST_CODE = 15;
					$display($time,":state3");
					end	

		state4: 
					begin
					BIST_CODE = 16;
					$display($time,":state4");
					end						
					
		default: BIST_CODE = 0;
 
endcase
 
end

endmodule

