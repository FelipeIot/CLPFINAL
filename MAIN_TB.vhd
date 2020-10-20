library IEEE;
use IEEE.std_logic_1164.all;
--Declaracion de la entidad
entity MAIN_TB is




end;



architecture MATRIXLED_TB_ARQ of MAIN_TB is
--Declarativa de la architure
	component PROBADORDOBLE is
	generic(
		N:natural:=36
	);
	
	port(
		HEX0:out std_logic_Vector(6 downto 0);
		HEX1:out std_logic_Vector(6 downto 0);
		HEX2:out std_logic_Vector(6 downto 0);
		HEX3:out std_logic_Vector(6 downto 0);
		HEX4:out std_logic_Vector(6 downto 0);
		LEDR:out std_logic_Vector(9 downto 0);
		SW:in std_logic_Vector(9 downto 0);
		CLOCK_50: in std_logic;
		GPIO_0:out std_logic_Vector(35 downto 0);
		GPIO_1:out std_logic_Vector(35 downto 0)
	
	);
	end component;	

	
	
	
	signal HEX0_tb:std_logic_Vector(6 downto 0);
	signal HEX1_tb:std_logic_Vector(6 downto 0);
	signal HEX2_tb:std_logic_Vector(6 downto 0);
	signal HEX3_tb:std_logic_Vector(6 downto 0);
	signal HEX4_tb:std_logic_Vector(6 downto 0);
	
	signal LEDR_tb:std_logic_Vector(9 downto 0);
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
	DUT: PROBADORDOBLE
	port map(
		HEX0=>HEX0_tb,
		HEX1=>HEX1_tb,
		HEX2=>HEX2_tb,
		HEX3=>HEX3_tb,
		HEX4=>HEX4_tb,
		LEDR=>LEDR_tb,
	
		SW=>SW_tb,
		CLOCK_50=>CLOCK_50_tb,
		GPIO_0=>GPIO_0_tb,
		GPIO_1=>GPIO_1_tb
	);
end;
