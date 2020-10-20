library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Declaracion de la entidad
entity MUX2A1 is

	port(
		
		I0:in std_logic;
		I1:in std_logic;
		S:in std_logic;
		Z:out std_logic
	
	);

end;








architecture MUX2A1_ARQ of MUX2A1 is
--Declarativa de la architure

 

begin
--Parte descriptiva
	process(I0,I1,S)
	begin 
		if S='0' then Z<=I0;
		else Z<=I1;
		end if;
	end process;
	

	
	
	
end;
