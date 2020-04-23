LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

--	Misalkan Nilai N = 3;

ENTITY Statistics IS
	PORT
	(
		DIN			:	IN		STD_LOGIC_VECTOR	(2 DOWNTO 0);
		DOUT_MODE	:	IN		STD_LOGIC_VECTOR	(1 DOWNTO 0);
		DOUT			:	OUT	STD_LOGIC_VECTOR	(2 DOWNTO 0);
		CLK			:	INOUT	STD_LOGIC;
		RESET			:	INOUT	STD_LOGIC;
		GT1			:	OUT	STD_LOGIC;
		GT2			:	OUT	STD_LOGIC;
		GT3			:	OUT	STD_LOGIC;
		ZI				:	INOUT	STD_LOGIC;
		EN1			:	IN		STD_LOGIC;
		EN2			:	IN		STD_LOGIC;
		EN3			:	IN		STD_LOGIC;
		ESUM			:	IN		STD_LOGIC;
		ENC			:	IN		STD_LOGIC;
		S2				:	IN		STD_LOGIC;
		S3				:	IN		STD_LOGIC;
		CLR			:	IN		STD_LOGIC;
		CIN			:	IN		STD_LOGIC_VECTOR	(2 DOWNTO 0);
		COUT			:	OUT	STD_LOGIC_VECTOR	(2 DOWNTO 0)
	);
END Statistics;

ARCHITECTURE Stat OF Statistics IS

	SIGNAL	OUT_FA,OUT_SUM,OUT_R_1,OUT_R_2,OUT_R_3,OUT_S,OUT_M_2,OUT_M_3	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL	OUT_CV	:	STD_LOGIC_VECTOR	(2 DOWNTO 0);
	SIGNAL	OUT_C		:	INTEGER;

	COMPONENT Generic_MUX_2to1
		GENERIC
		(
			N	:	INTEGER
		);

		PORT
		(
			IN_A	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			IN_B	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			OUT_X	:	OUT	STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			SEL	:	IN		STD_LOGIC
		);
	END COMPONENT Generic_MUX_2to1;
	
	COMPONENT Generic_MUX_4to1 is
		GENERIC
		(
			N	:	INTEGER
		);
		
		PORT
		(
			IN_A	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			IN_B	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			IN_C	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			IN_D	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			OUT_X	:	OUT	STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			SEL	:	IN		STD_LOGIC_VECTOR	(1   DOWNTO 0)
		);
	END COMPONENT Generic_MUX_4to1;
	
	COMPONENT Generic_Full_Adder IS
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
	END COMPONENT Generic_Full_Adder;
	
	COMPONENT Generic_Register is
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
	END COMPONENT Generic_Register;
	
	COMPONENT Generic_Comparator_Greater_Than is
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
	END COMPONENT Generic_Comparator_Greater_Than;
	
	COMPONENT Generic_Shift_Register IS
		GENERIC
		(
			N	: INTEGER
		);
		
		PORT
		(
			CLOCK	:	IN		STD_LOGIC;
			CLEAR	:	IN		STD_LOGIC;
			IN_A	:	IN		STD_LOGIC_VECTOR	(N-1 DOWNTO 0);
			OUT_X	:	INOUT	STD_LOGIC_VECTOR	(N-1 DOWNTO 0)
		);
	END COMPONENT Generic_Shift_Register;
	
	COMPONENT Generic_Counter_Register is
		GENERIC
		(
			M	:	INTEGER
		);
		
		PORT
		(
			RESET		:	IN		STD_LOGIC;
			CLOCK		:	IN		STD_LOGIC;
			ENABLE	:	IN		STD_LOGIC;
			OUT_X		:	INOUT	STD_LOGIC_VECTOR	(M-1 DOWNTO 0)
		);
	END COMPONENT Generic_Counter_Register;

BEGIN

	Count_STAT	:	Generic_Counter_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			RESET		=>	RESET,
			CLOCK		=>	CLK,
			ENABLE	=>	ENC,
			OUT_X		=>	OUT_CV
		);
	
	Count_Reg	:	PROCESS(OUT_C)
	VARIABLE	K	:	INTEGER	:= 3;
	BEGIN
		K	:=	K-1;
		OUT_C	<= TO_INTEGER(UNSIGNED(OUT_CV));
		IF (OUT_C = K) THEN
			ZI <=	'1';
		ELSE
			ZI	<=	'0';
		END IF;
	END PROCESS Count_Reg;
	
	FA_STAT	:	Generic_Full_Adder
		GENERIC MAP(3)

		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_1,
			C_IN	=>	CIN,
			C_OUT	=>	COUT,
			OUT_X	=>	OUT_FA
		);
		
	Reg_SUM_STAT	:	Generic_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			RESET		=>	RESET,
			CLOCK		=>	CLK,
			ENABLE	=>	ESUM,
			IN_A		=>	OUT_FA,
			OUT_X		=>	OUT_SUM
		);
		
	Shift_Reg_STAT	:	Generic_Shift_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			CLOCK	=>	CLK,
			CLEAR	=>	CLR,
			IN_A	=>	OUT_SUM,
			OUT_X	=>	OUT_S
		);
		
	MUX_1_STAT	:	Generic_MUX_4to1
		GENERIC MAP(3)
		
		PORT MAP
		(
			IN_A	=>	OUT_S,
			IN_B	=>	OUT_R_1,
			IN_C	=>	OUT_R_2,
			IN_D	=>	OUT_R_3,
			OUT_X	=>	DOUT,
			SEL	=>	DOUT_MODE
		);
		
	Reg_1_STAT	:	Generic_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			RESET		=>	RESET,
			CLOCK		=>	CLK,
			ENABLE	=>	EN1,
			IN_A		=>	DIN,
			OUT_X		=>	OUT_R_1
		);
		
	MUX_2_STAT	:	Generic_MUX_2to1
		GENERIC MAP(3)

		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_1,
			OUT_X	=>	OUT_M_2,	
			SEL	=>	S2
		);
		
	Reg_2_STAT	:	Generic_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			RESET		=>	RESET,
			CLOCK		=>	CLK,
			ENABLE	=>	EN2,
			IN_A		=>	OUT_M_2,
			OUT_X		=>	OUT_R_2
		);
		
	MUX_3_STAT	:	Generic_MUX_2to1
		GENERIC MAP(3)

		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_2,
			OUT_X	=>	OUT_M_3,	
			SEL	=>	S3
		);
	
	Reg_3_STAT	:	Generic_Register
		GENERIC MAP(3)
		
		PORT MAP
		(
			RESET		=>	RESET,
			CLOCK		=>	CLK,
			ENABLE	=>	EN3,
			IN_A		=>	OUT_M_3,
			OUT_X		=>	OUT_R_3
		);
	
	Comp_1_STAT : Generic_Comparator_Greater_Than
		GENERIC MAP(3)
		
		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_1,
			OUT_X	=>	GT1
		);
		
	Comp_2_STAT : Generic_Comparator_Greater_Than
		GENERIC MAP(3)
		
		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_2,
			OUT_X	=>	GT2
		);
		
	Comp_3_STAT : Generic_Comparator_Greater_Than
		GENERIC MAP(3)
		
		PORT MAP
		(
			IN_A	=>	DIN,
			IN_B	=>	OUT_R_3,
			OUT_X	=>	GT3
		);
END Stat;