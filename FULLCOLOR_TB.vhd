library IEEE;
use IEEE.std_logic_1164.all;
--Declaracion de la entidad
entity FULLCOLOR_TB is




end;



architecture MATRIXLED_TB_ARQ of FULLCOLOR_TB is
--Declarativa de la architure
	component FULLCOLOR is
	port(
		SW_I:in std_logic_Vector(9 downto 0);
		CLOCK_50_I: in std_logic;
		GPIO_0_O:out std_logic_Vector(35 downto 0);
		GPIO_1_O:out std_logic_Vector(35 downto 0)

	);
	end component;	

	
	
	signal SW_tb: std_logic_Vector(9 downto 0):="0000000000";
	signal CLOCK_50_tb:  std_logic:='0';

	signal GPIO_0_tb: std_logic_Vector(35 downto 0);
	signal GPIO_1_tb: std_logic_Vector(35 downto 0);

begin
--Parte descriptiva
	CLOCK_50_tb<=not CLOCK_50_tb after 10 ns;
	SW_tb(0)<='1' after 2000 ns;
	SW_tb(1)<='1' after 4000 ns;
	SW_tb(2)<='1' after 6000 ns;
	DUT: FULLCOLOR
	port map(
	
		SW_I=>SW_tb,
		CLOCK_50_I=>CLOCK_50_tb,
		GPIO_0_O=>GPIO_0_tb,
		GPIO_1_O=>GPIO_1_tb
	);
end;
