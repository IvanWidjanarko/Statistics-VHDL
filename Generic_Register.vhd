LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Generic_Register is
	GENERIC
	(
		N	:	INTEGER
	);
	
	PORT
	(
		RESET		:	IN		STD_LOGIC;
		CLOCK		:	IN		STD_LOGIC;
		ENABLE	:	IN		STD_LOGIC;
		IN_A		:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
		OUT_X		:	OUT	STD_LOGIC_VECTOR	(N-1 DOWNTO 0)
	);
END Generic_Register;

ARCHITECTURE Gen_Register OF Generic_Register IS
BEGIN
	Generic_Reg : PROCESS(CLOCK)
	BEGIN
		IF (RESET = '0') THEN
			IF (ENABLE = '1') THEN
				IF (CLOCK'EVENT AND CLOCK = '1') THEN
					OUT_X	<=	IN_A;
				END IF;
			END IF;
		ELSIF (RESET = '1') THEN
			OUT_X	<=	"000";
		END IF;
	END PROCESS Generic_Reg;
END Gen_Register;