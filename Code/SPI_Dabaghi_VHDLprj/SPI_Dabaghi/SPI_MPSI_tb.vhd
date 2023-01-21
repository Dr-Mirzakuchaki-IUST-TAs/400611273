LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY SPI_MPSI_tb IS
END SPI_MPSI_tb;
 
ARCHITECTURE behavior OF SPI_MPSI_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
--    COMPONENT SPI_MOSI
--    PORT(
--         CLK_SYS : IN  std_logic;
--         CONV_START : IN  std_logic;
--         SCK : IN  std_logic;
--         CS_n : OUT  std_logic;
--         MOSI : OUT  std_logic
--        );
--    END COMPONENT;
    

   --Inputs
   signal CLK_SYS 	      : std_logic := '0';
   signal CONV_START       : std_logic := '0';
   signal SCK 			      : std_logic := '0';
	signal Data_In_INT		: STD_LOGIC_VECTOR (13 DOWNTO 0)	:=  (OTHERS => '0');

 	--Outputs
   signal CS_n 				: std_logic;
   signal MOSI             : std_logic;
	
	--Internal signal
	signal SCK_CONV_START	: std_logic := '0';

   -- Clock period definitions
   constant CLK_SYS_period : time := 66.6 ns; 	---15MHz
	constant SCK_period 		: time := 66.6 ns;	---15MHz

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.SPI_MOSI PORT MAP (
          CLK_SYS => CLK_SYS,
          CONV_START => CONV_START,
          SCK => SCK,
          CS_n => CS_n,
          MOSI => MOSI
        );

   -- Clock process definitions
   CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
	
	
	--- SCK start generator
	SCK_CONV_Start_Pro:	process
	begin
		SCK_CONV_START	<=	'0','1' after 632.7ns,'0' after 1520ns, '1' after 1740ns, '0' after 2700ns;
	wait;
	end process SCK_CONV_Start_Pro;
	
	
	---SCK generator
	SCK_Pro:	process
	begin
		if	(SCK_CONV_START	=	'1')	then
			SCK	<=	'0';
			wait for SCK_period/2;
			SCK	<=	'1';
			wait for SCK_period/2;
		else
			SCK	<=	'0';
			wait until	SCK_CONV_START	=	'1';
		end if;
		
	end process SCK_Pro;
	
	
	---CONV_START generator
	start_Pro:	process
	begin
		CONV_START	<=	'0','1' after 490ns,'0' after 530ns, '1' after 1630ns, '0' after 1670 ns;
	wait;
	end process start_Pro;


END;
