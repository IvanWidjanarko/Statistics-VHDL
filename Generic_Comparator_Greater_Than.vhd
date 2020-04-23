LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Generic_Comparator_Greater_Than is
	GENERIC
	(
		N	:	INTEGER
	);
	
	PORT
	(
		IN_A	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
		IN_B	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
		OUT_X	:	OUT	STD_LOGIC
	);
END Generic_Comparator_Greater_Than;

ARCHITECTURE Gen_Comparator_Greater_Than OF Generic_Comparator_Greater_Than IS
BEGIN
	Generic_Compare_Greater_Than : PROCESS(IN_B)
	BEGIN
		IF (IN_A >= IN_B) THEN
			OUT_X	<=	'1';
		ELSE
			OUT_X	<=	'0';
		END IF;
	END PROCESS Generic_Compare_Greater_Than;
END Gen_Comparator_Greater_Than;