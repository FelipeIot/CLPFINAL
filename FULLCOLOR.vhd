library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Declaracion de la entidad
entity FULLCOLOR is

port(
--LEDR:out std_logic_Vector(9 downto 0);
SW_I:in std_logic_Vector(9 downto 0);
CLOCK_50_I: in std_logic;
GPIO_0_O:out std_logic_Vector(35 downto 0);
GPIO_1_O:out std_logic_Vector(35 downto 0)

);

end;








architecture FULLCOLOR_ARQ of FULLCOLOR is
--Declarativa de la architure
constant PRESCALADOR : integer := 10;
constant NBITSPORFILA : integer := 16;
constant NTOGGLE : integer := 200;
constant NBITCHANNEL: integer:=16;
constant NINTEGRADOS: integer:=24;
constant NCHANNEL: integer:=16;
constant NFILAS: integer:=4;
constant NGCLKVSYNC: integer:=50;
constant NPULSESYNC: integer:=2;
constant NCICLOSRETARDO: integer:=25;
constant NGLCLKSCANLINE: integer:=1025;
constant NFILASLEDS: integer:=8;
constant NCICLOSREFRESH : integer := 100;
constant NCICLOSHALF : integer := 20;




signal contadorprescaler : integer range 0 to 1000;
signal contadorbits : integer range 0 to 1000;
signal contadorbarrido : integer range 0 to 8;
signal contadorcanales: integer range 0 to 16;
signal contadorfilas: integer range 0 to 4;
signal contadorgclksync: integer range 0 to 200;
signal contadorpulsesync: integer range 0 to 10;
signal contadorretardo: integer range 0 to 200;
signal contadorHalfGlck: integer range 0 to 5000;
signal contadorrefresh : integer range 0 to 10000000;
signal contadorHalfSoftReset: integer range 0 to 5000;

signal GLCK:std_logic:='0';
signal CLK: std_logic:='0';
signal strobe: std_logic;
signal R: std_logic;
signal G: std_logic;
signal B: std_logic;
signal barrido:  std_logic_Vector(2 downto 0);


signal bittoggle: std_logic:='0';
signal startbit: std_logic:='0';


type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13);  
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
			--Cargando información
			when s0 =>
				state<=s1;
				strobe<='0';
				R<=((SW_I(0) and not(SW_I(3) or SW_I(4) or SW_I(5))) or (SW_I(3) and bittoggle ));
				G<=((SW_I(1) and not(SW_I(3) or SW_I(4) or SW_I(5))) or (SW_I(4) and bittoggle ));
				B<=((SW_I(2) and not(SW_I(3) or SW_I(4) or SW_I(5))) or (SW_I(5) and bittoggle ));

				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

					if contadorbarrido>=(NFILASLEDS-1) then
						contadorbarrido<=0;

					else
						contadorbarrido<=contadorbarrido+1;
					end if;

				else
						contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				CLK<='0';
			--Cargando información
			when s1 =>
				CLK<='1';
				state<=s2;
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;

						else
							contadorbarrido<=contadorbarrido+1;

						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				if contadorbits>=(NBITCHANNEL*NINTEGRADOS-2) then
					state<=s2;
					contadorbits<=0;


				else
					state<=s0;
					contadorbits<=contadorbits+1;
				end if;
			--Cargando información
			when s2 =>
				CLK<='0';
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;


						else
							contadorbarrido<=contadorbarrido+1;

						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				strobe<='1';
				state<=s3;
			--Cargando información
			when s3 =>
				CLK<='1';
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;

						else
							contadorbarrido<=contadorbarrido+1;
						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				state<=s4;
			--Cargando información	
			when s4 =>
				CLK<='0';
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;

						else
							contadorbarrido<=contadorbarrido+1;
						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				R<='0';
				G<='0';
				B<='0';

				strobe<='0';
				bittoggle<=not bittoggle;
				if contadorcanales>=(NCHANNEL-1) then
					state<=s5;
					contadorcanales<=0;
				else
					state<=s0;
					contadorcanales<=contadorcanales+1;
				end if;
			--Cargando información
			when s5 =>

				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;

						else
							contadorbarrido<=contadorbarrido+1;
						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;

				if contadorfilas>=(NFILAS-1) then
					contadorfilas<=0;
					state<=s6;
				else
					contadorfilas<=contadorfilas+1;
					state<=s0;
				end if;
			--VSYNC	
			when s6 =>
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					contadorHalfGlck<=0;
					barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

						if contadorbarrido>=(NFILASLEDS-1) then
							contadorbarrido<=0;

						else
							contadorbarrido<=contadorbarrido+1;
						end if;

				else
					contadorHalfGlck<=contadorHalfGlck+1;
				end if;
				if contadorgclksync>(NGCLKVSYNC*2-1) then
					state<=s7;
					contadorgclksync<=0;
				else
					contadorgclksync<=contadorgclksync+1;
					state<=s6;
				end if;
			--VSYNC
			when s7 =>
				GLCK<='0';
				CLK<='0';
				strobe<='1';
				state<=s8;
			--VSYNC	
			when s8 =>
				CLK<=not CLK;
				if contadorpulsesync>=(2*NPULSESYNC-1)then
					state<=s9;
					contadorpulsesync<=0;
				else
					state<=s8;
					contadorpulsesync<=contadorpulsesync+1;
				end if;
			--PAUSA
			when s9 =>

				strobe<='0';
				if contadorretardo>=NCICLOSRETARDO then
					state<=s10;
					contadorretardo<=0;
					contadorHalfGlck<=0;
				else
					contadorretardo<=contadorretardo+1;
					state<=s9;
				end if;
				
			--DESPLIGUE Y BARRIDO
			when s10 =>
				GLCK<=not GLCK;
				if contadorHalfGlck>=(NGLCLKSCANLINE*2-1)then
					state<=s11;
					contadorHalfGlck<=0;
				else
					contadorHalfGlck<=contadorHalfGlck+1;
					state<=s10;
				end if;
			--DESPLIGUE Y BARRIDO
			when s11 =>

				if contadorretardo>=NCICLOSRETARDO then
					state<=s12;
					contadorretardo<=0;
				else
					contadorretardo<=contadorretardo+1;
					state<=s11;
				end if;

			--DESPLIGUE Y BARRIDO
			when s12 =>
				barrido <= std_logic_vector(to_unsigned(contadorbarrido, barrido'length));

				if contadorbarrido>=(NFILASLEDS-1) then
					contadorbarrido<=0;
					if contadorrefresh>=NCICLOSREFRESH then
						contadorrefresh<=0;

						bittoggle<= not bittoggle;


						state<=s13;
						strobe<='1';
						CLK<='0';
						contadorHalfSoftReset<=0;

					else
						contadorrefresh<=contadorrefresh+1;
						state<=s10;
					end if;


				else
					contadorbarrido<=contadorbarrido+1;
					state<=s10;
				end if;
			--SOFT RESET
			when s13 =>

				CLK<=not CLK;
				contadorHalfSoftReset<=contadorHalfSoftReset+1;
				if contadorHalfSoftReset>(NCICLOSHALF-1) then
					state<=s0;
					strobe<='0';
				end if;






			when others=>
			state<=s0;
			end case;

		end if;
	end if;


end process;

--LEDR<= SW_I;

GPIO_0_O(1)<=GLCK;
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
GPIO_0_O(26)<=GLCK;
GPIO_0_O(24)<=CLK;


GPIO_0_O(22)<=GLCK;
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


GPIO_1_O(1)<=GLCK;
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
GPIO_1_O(26)<=GLCK;
GPIO_1_O(24)<=CLK;


GPIO_1_O(22)<=GLCK;
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
