LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Generic_Counter_Register is
	GENERIC
	(
		M	:	INTEGER
	);
	
	PORT
	(
		RESET		:	IN		STD_LOGIC;
		CLOCK		:	IN		STD_LOGIC;
		ENABLE	:	IN		STD_LOGIC;
		OUT_X		:	INOUT	STD_LOGIC_VECTOR	(M-1 DOWNTO 0) := "000"
	);
END Generic_Counter_Register;

ARCHITECTURE Gen_Counter_Register OF Generic_Counter_Register IS
BEGIN
	Generic_Count_Reg : PROCESS(CLOCK)
	BEGIN
		IF (RESET = '0') THEN
			IF (ENABLE = '1') THEN
				IF (CLOCK'EVENT AND CLOCK = '1') THEN
					OUT_X <= OUT_X + 1;
				END IF;
			END IF;
		ELSIF (RESET = '1') THEN
			OUT_X	<=	"000";
		END IF;
	END PROCESS Generic_Count_Reg;
END Gen_Counter_Register;