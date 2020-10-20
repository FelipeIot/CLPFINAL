library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Declaracion de la entidad
entity MONOCOLOR is

	port(
		--LEDR:out std_logic_Vector(9 downto 0);
		SW_I:in std_logic_Vector(9 downto 0);
		CLOCK_50_I: in std_logic;
		GPIO_0_O:out std_logic_Vector(35 downto 0);
		GPIO_1_O:out std_logic_Vector(35 downto 0)
	
	);

end;








architecture MONOCOLOR_ARQ of MONOCOLOR is
--Declarativa de la architure
constant PRESCALADOR : integer := 12;
constant NBITSPORFILA : integer := 384;
constant NTOGGLE : integer := 800;

signal contadorprescaler : integer range 0 to 10000;
signal contadorbits : integer range 0 to 10000;
signal contadorbarrido : integer range 0 to 8;
signal contadortoggle : integer range 0 to 100000;



signal CLK: std_logic;
signal strobe: std_logic;
signal R: std_logic;
signal G: std_logic;
signal B: std_logic;
signal barrido:  std_logic_Vector(2 downto 0);

signal bittoggle: std_logic:='0';
signal startbit: std_logic:='0';

type state_type is (s0,s1,s2,s3,s4,s5,s6,s7);  
signal state: state_type ; 

begin
--Parte descriptiva
	process(CLOCK_50_I)
	begin 
		if rising_edge(CLOCK_50_I) then
			contadorprescaler<=contadorprescaler+1;
			if contadorprescaler>=(PRESCALADOR-1) then
				contadorprescaler<=0;
				case state is
						--CARGAMOS INFORMACION
						when s0 => 
							state<=s1;
							R<=SW_I(0) or (SW_I(3) and bittoggle );
							G<=SW_I(1) or (SW_I(4) and bittoggle);
							B<=SW_I(2) or (SW_I(5) and bittoggle);
							bittoggle<=not bittoggle;
							CLK<='0';
						--CARGAMOS INFORMACION
						when s1 => 
							CLK<='1';
							state<=s2;
							if contadorbits>=(NBITSPORFILA-1) then
								state<=s2;
								contadorbits<=0;
								
							else
								state<=s0;
								contadorbits<=contadorbits+1;
							end if;
							
						--DESPLEGAMOS INFORMACION	
						when s2 => 
							CLK<='0';
							strobe<='1';
							contadorbarrido<=contadorbarrido+1;
							if contadorbarrido>=7 then
								contadorbarrido<=0;
						      contadortoggle<=contadortoggle+1;
								if contadortoggle>(NTOGGLE-1) then
									contadortoggle<=0;
									startbit<=not startbit;
								end if;
							end if;
							state<=s3;
						--EMPEZAMOS EL CICLO DE NUEVO
						when s3 => 
							strobe<='0';
							state<=s0;
							bittoggle<=startbit;
							
							barrido <= std_logic_vector(to_unsigned(contadorbarrido, BARRIDO'length));
						when others=> 
							state<=s0;
				end case;
				
			end if;
		end if;
	
		
	end process;
	
	--LEDR<= SW_I;
	
	GPIO_0_O(1)<='0';
	GPIO_0_O(3)<=CLK;
	GPIO_0_O(5)<=barrido(2);
	GPIO_0_O(7)<=barrido(0);
	GPIO_0_O(9)<=B;
	GPIO_0_O(11)<=R;
	GPIO_0_O(13)<=B;
	GPIO_0_O(15)<=R;
	GPIO_0_O(17)<=G;
	GPIO_0_O(19)<=G;
	GPIO_0_O(21)<=barrido(1);
	GPIO_0_O(23)<=strobe;

	
	GPIO_0_O(25)<=barrido(2);
	GPIO_0_O(27)<=barrido(0);
	GPIO_0_O(29)<=B;
	GPIO_0_O(31)<=R;
	GPIO_0_O(33)<=B;
	GPIO_0_O(35)<=R;
	GPIO_0_O(34)<=G;
	GPIO_0_O(32)<=G;
	GPIO_0_O(30)<=barrido(1);
	GPIO_0_O(28)<=strobe;
	GPIO_0_O(26)<='0';
	GPIO_0_O(24)<=CLK;
	

	GPIO_0_O(22)<='0';
	GPIO_0_O(20)<=CLK;
	GPIO_0_O(18)<=barrido(2);
	GPIO_0_O(16)<=barrido(0);
	GPIO_0_O(14)<=B;
	GPIO_0_O(12)<=R;
	GPIO_0_O(10)<=B;
	GPIO_0_O(8)<=R;
	GPIO_0_O(6)<=G;
	GPIO_0_O(4)<=G;
	GPIO_0_O(2)<=barrido(1);
	GPIO_0_O(0)<=strobe;
	
	
	GPIO_1_O(1)<='0';
	GPIO_1_O(3)<=CLK;
	GPIO_1_O(5)<=barrido(2);
	GPIO_1_O(7)<=barrido(0);
	GPIO_1_O(9)<=B;
	GPIO_1_O(11)<=R;
	GPIO_1_O(13)<=B;
	GPIO_1_O(15)<=R;
	GPIO_1_O(17)<=G;
	GPIO_1_O(19)<=G;
	GPIO_1_O(21)<=barrido(1);
	GPIO_1_O(23)<=strobe;

	
	GPIO_1_O(25)<=barrido(2);
	GPIO_1_O(27)<=barrido(0);
	GPIO_1_O(29)<=B;
	GPIO_1_O(31)<=R;
	GPIO_1_O(33)<=B;
	GPIO_1_O(35)<=R;
	GPIO_1_O(34)<=G;
	GPIO_1_O(32)<=G;
	GPIO_1_O(30)<=barrido(1);
	GPIO_1_O(28)<=strobe;
	GPIO_1_O(26)<='0';
	GPIO_1_O(24)<=CLK;
	

	GPIO_1_O(22)<='0';
	GPIO_1_O(20)<=CLK;
	GPIO_1_O(18)<=barrido(2);
	GPIO_1_O(16)<=barrido(0);
	GPIO_1_O(14)<=B;
	GPIO_1_O(12)<=R;
	GPIO_1_O(10)<=B;
	GPIO_1_O(8)<=R;
	GPIO_1_O(6)<=G;
	GPIO_1_O(4)<=G;
	GPIO_1_O(2)<=barrido(1);
	GPIO_1_O(0)<=strobe;
	
	
	
end;
