-----------------------------------------
-- Engineer: Niloufar Dabaghi Daryan
-- Module Name:    SPI_MOSI/SDO Behavioral 
-----------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_MOSI is
    Port ( 
	 
	-----INPUTS-----
			  CLK_SYS    : in  STD_LOGIC;
           CONV_START : in  STD_LOGIC;
           SCK        : in  STD_LOGIC;
	-----OUTPUTS-----
           CS_n       : out  STD_LOGIC;
           MOSI       : out  STD_LOGIC
		);
		
end SPI_MOSI;

architecture Behavioral of SPI_MOSI is

	---in/outs---
	signal CONV_START_INT	:   STD_LOGIC	:='0';
	signal CS_n_INT			:   STD_LOGIC	:='1';
	signal MOSI_INT			:   STD_LOGIC	:='0';
	signal Data_In_INT		:   STD_LOGIC_VECTOR (13 DOWNTO 0)	:=  (OTHERS => '0');
	--signal Data_In_INT		:   STD_LOGIC_VECTOR (23 DOWNTO 0)	:=  (OTHERS => '0');
	
	---Ccontrol signals---
	signal	Bit_CNT			:	unsigned	(3 DOWNTO 0)				:= "1101"; 	---MSB FIRST----
	--signal	Bit_CNT			:	unsigned	(4 DOWNTO 0)				:= "10111"; 	---MSB FIRST----
	
	----STATES----
	type	FSM is	(idle, instruction, write_st, delay_instruction, delay_cs);
	signal state				:	FSM										:=	idle;
	----
	constant	Data_In			: STD_LOGIC_VECTOR (13 DOWNTO 0)	:=	"00100010000000";
	--constant	Data_In			: STD_LOGIC_VECTOR (23 DOWNTO 0)	:=	"001000100000000000000001";

begin
 
	----
	CS_n	<=	CS_n_INT;
	MOSI	<=	MOSI_INT;
	----
	
	Process(CLK_SYS)
	begin
	---
		if (rising_edge (CLK_SYS))	then
		
			----
			Data_IN_INT		<=	Data_In;
			CONV_START_INT	<=	CONV_START;
			----
			
			case	State	is
			---
			
				when idle	=>
				---
				MOSI_INT	<='0';
				Bit_CNT	<="1101";
				--Bit_CNT	<="10111";
				---
				
					if (CONV_START_INT='1')	then
						state	<=	delay_instruction;
						CS_n_INT	<='0';
					else
						state	<=	idle;
						CS_n_INT	<='1';
					end if;
				---
				
				when delay_instruction	=>
				---
					state		<=	instruction;
					CS_n_INT	<=	'0';
					MOSI_INT	<=	Data_IN_INT	(to_integer	(Bit_CNT));
					Bit_CNT	<=	Bit_CNT	-	1;
					---
			
				when instruction	=>
					---
					CS_n_INT	<=	'0';
					MOSI_INT	<=	Data_IN_INT	(to_integer	(Bit_CNT));
					---
					if	(Bit_CNT	/=6)	then
					--if	(Bit_CNT	/=16)	then
						state		<=	instruction;
						Bit_CNT	<=	Bit_CNT	-	1;
					else
						state	<=	write_st;
						--Bit_CNT	<=	"01111";
						Bit_CNT	<=	"0101";
					end if;
					---
					
				when	write_st	=>
				---
					CS_n_INT	<=	'0';
					MOSI_INT	<=	Data_IN_INT	(to_integer	(Bit_CNT));
					---
						if	(Bit_CNT	/=0)	then
							state		<=	write_st;
							Bit_CNT	<=	Bit_CNT	-	1;
						else
							state	<=	delay_cs;
							--Bit_CNT	<=	"10111";
							Bit_CNT	<=	"1101";
						end if;
						---
						
					when delay_cs	=>
					---
						state	<=	idle;
						CS_n_INT	<=	'0';
						MOSI_INT	<=	'0';
						Bit_CNT	<=	"1101";
						--Bit_CNT	<=	"10111";
					---

			end case;
			---
		
		end if;
		----
		
	end Process;

end Behavioral;

