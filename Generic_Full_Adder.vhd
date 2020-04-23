LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY Generic_Full_Adder IS
	GENERIC
	(
		N	:	INTEGER
	);

	PORT
	(
		IN_A	:	IN		STD_LOGIC_Vector	(N-1 DOWNTO 0);
		IN_B	:	IN		STD_LOGIC_Vector	(N-1 DOWNTO 0);
		C_IN	:	IN		STD_LOGIC_Vector	(N-1 DOWNTO 0);
		C_OUT	:	OUT	STD_LOGIC_Vector	(N-1 DOWNTO 0);
		OUT_X	:	OUT	STD_LOGIC_Vector	(N-1 DOWNTO 0)
	);
END Generic_Full_Adder;

ARCHITECTURE Gen_Full_Adder OF Generic_Full_Adder IS

BEGIN
	Generic_FA : PROCESS(IN_A,IN_B,C_IN)
	BEGIN
		OUT_X	<=	IN_A XOR IN_B XOR C_IN;
		C_OUT	<=	(IN_A AND IN_B) OR (C_IN AND IN_A) OR (C_IN AND IN_B);
	END PROCESS Generic_FA;
END Gen_Full_Adder;
