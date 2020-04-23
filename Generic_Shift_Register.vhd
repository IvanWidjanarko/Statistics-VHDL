LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY Generic_Shift_Register IS
	GENERIC
	(
		N	:	INTEGER
	);
	
	PORT
	(
		CLOCK	:	IN		STD_LOGIC;
		CLEAR	:	IN		STD_LOGIC;
		IN_A	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
		OUT_X	:	INOUT	STD_LOGIC_VECTOR	(N-1 DOWNTO 0)
	);
END Generic_Shift_Register;
 
ARCHITECTURE Gen_Shift_Reg OF Generic_Shift_Register IS
BEGIN
 
	PROCESS (CLOCK)
	BEGIN
		IF	CLEAR = '1' THEN
			OUT_X <= "000";
		ELSIF (CLOCK'EVENT AND CLOCK='1') THEN
			FOR I IN 0 TO N-2 LOOp
				OUT_X(I) <= IN_A(I+1);
			END LOOP;
			OUT_X(N-1) <= '0';
		END IF;
	END PROCESS;
END Gen_Shift_Reg;
