library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Declaracion de la entidad
entity PROBADORDOBLE is
	
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

end;








architecture PROBADORDOBLE_ARQ of PROBADORDOBLE is
--Declarativa de la architure
	component FULLCOLOR is
	port(
		SW_I:in std_logic_Vector(9 downto 0);
		CLOCK_50_I: in std_logic;
		GPIO_0_O:out std_logic_Vector(35 downto 0);
		GPIO_1_O:out std_logic_Vector(35 downto 0)
	);
	end component;	
	
	
	component MONOCOLOR is
	port(
		SW_I:in std_logic_Vector(9 downto 0);
		CLOCK_50_I: in std_logic;
		GPIO_0_O:out std_logic_Vector(35 downto 0);
		GPIO_1_O:out std_logic_Vector(35 downto 0)
	);
	end component;
	
	component MUX2A1 is
	port(
		I0:in std_logic;
		I1:in std_logic;
		S:in std_logic;
		Z:out std_logic
	);
	end component;	

	
	
	signal salidafull1:std_logic_Vector(35 downto 0);
	signal salidafull2:std_logic_Vector(35 downto 0);
	signal salidamono1:std_logic_Vector(35 downto 0);
	signal salidamono2:std_logic_Vector(35 downto 0);
	
	signal salidaz:std_logic_Vector(35 downto 0);


begin
--Parte descriptiva

	process(SW(9))
	begin
		if SW(9)='1' then
		
			HEX4(0)<='0';
			HEX4(1)<='0';
			HEX4(2)<='0';
			HEX4(3)<='1';
			HEX4(4)<='0';
			HEX4(5)<='0';
			HEX4(6)<='0';
			
			HEX3(0)<='0';
			HEX3(1)<='1';
			HEX3(2)<='0';
			HEX3(3)<='0';
			HEX3(4)<='1';
			HEX3(5)<='0';
			HEX3(6)<='0';
			
			HEX2(0)<='0';
			HEX2(1)<='0';
			HEX2(2)<='0';
			HEX2(3)<='0';
			HEX2(4)<='0';
			HEX2(5)<='0';
			HEX2(6)<='1';
			
			HEX1(0)<='0';
			HEX1(1)<='0';
			HEX1(2)<='1';
			HEX1(3)<='0';
			HEX1(4)<='0';
			HEX1(5)<='1';
			HEX1(6)<='0';
			
			HEX0(0)<='0';
			HEX0(1)<='1';
			HEX0(2)<='0';
			HEX0(3)<='0';
			HEX0(4)<='0';
			HEX0(5)<='0';
			HEX0(6)<='0';
			
		else
			HEX4(0)<='0';
			HEX4(1)<='1';
			HEX4(2)<='1';
			HEX4(3)<='1';
			HEX4(4)<='0';
			HEX4(5)<='0';
			HEX4(6)<='0';
			
			HEX3(0)<='0';
			HEX3(1)<='1';
			HEX3(2)<='0';
			HEX3(3)<='0';
			HEX3(4)<='1';
			HEX3(5)<='0';
			HEX3(6)<='0';
			
			HEX2(0)<='0';
			HEX2(1)<='0';
			HEX2(2)<='0';
			HEX2(3)<='0';
			HEX2(4)<='0';
			HEX2(5)<='0';
			HEX2(6)<='1';
			
			HEX1(0)<='0';
			HEX1(1)<='1';
			HEX1(2)<='0';
			HEX1(3)<='0';
			HEX1(4)<='1';
			HEX1(5)<='0';
			HEX1(6)<='0';
			
			HEX0(0)<='1';
			HEX0(1)<='0';
			HEX0(2)<='0';
			HEX0(3)<='1';
			HEX0(4)<='1';
			HEX0(5)<='1';
			HEX0(6)<='1';
		end if;
	end process;
	
	


	U0: FULLCOLOR
	port map(
		SW_I=>SW,
		CLOCK_50_I=>CLOCK_50,
		GPIO_0_O=>salidafull1,
		GPIO_1_O=>salidafull2
	);
	
	U1: MONOCOLOR
	port map(
		SW_I=>SW,
		CLOCK_50_I=>CLOCK_50,
		GPIO_0_O=>salidamono1,
		GPIO_1_O=>salidamono2
	);
	
	mux_i: for i in 0 to N-1 generate
	mux_inst: MUX2A1 port map
	(
		I0=>salidafull1(i),
		I1=>salidamono1(i),
		S=>SW(9),
		Z=>salidaz(i)
		
	);
	end generate;


	
	
	LEDR<= SW;
	
	GPIO_0<=salidaz;
	GPIO_1<=salidaz;

	
	
	
end;
