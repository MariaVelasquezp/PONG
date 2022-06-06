LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
------------------------------------------------------------------
ENTITY univ_bin_counter_cont IS
GENERIC ( N : INTEGER := 4);
PORT ( 	clk 		: IN STD_LOGIC;
			rst 			: IN STD_LOGIC;
			ena 			: IN STD_LOGIC;
			syn_clr 		: IN STD_LOGIC;
			load 			: IN STD_LOGIC;
			up 			: IN STD_LOGIC;
			d 				: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			max_tick 	: OUT STD_LOGIC;
			min_tick 	: OUT STD_LOGIC;
			counter 		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			MaxC 			: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0));
END ENTITY;
------------------------------------------------------------------
ARCHITECTURE rtl OF univ_bin_counter_cont IS
CONSTANT ONES 			: UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '1');
CONSTANT ZEROS 		: UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL 	count_s	 	: UNSIGNED(N-1 DOWNTO 0);
SIGNAL 	count_next 	: UNSIGNED(N-1 DOWNTO 0);

SIGNAL 	countern_s 	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL 	d_s 			: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL 	eq 			: STD_LOGIC;

BEGIN
	countern_s <= 	STD_LOGIC_VECTOR(count_next);
	
	eq <= '1' WHEN (countern_s = MaxC) ELSE
			'0';
	d_s <=	STD_LOGIC_VECTOR(ZEROS) WHEN (eq = '1') ELSE
				d;

	count_next <= 	(OTHERS => '0') WHEN syn_clr='1' ELSE
						UNSIGNED(d_s) WHEN load ='1' ELSE
						count_s + 1 WHEN (ena ='1' AND up='1') ELSE
						count_s - 1 WHEN (ena ='1' AND up='0') ELSE
						count_s;

						
	PROCESS(clk,rst)
		VARIABLE temp : UNSIGNED(N-1 DOWNTO 0);
	BEGIN
		IF	(rst='1') THEN
			temp:= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (ena='1') THEN
			temp := count_next;
			END IF;
		END IF;
		counter <= STD_LOGIC_VECTOR(temp);
		count_s <= temp;
	END PROCESS;
	
	max_tick <= '1' WHEN (eq = '1') ELSE '0'; -- ((count_s = ONES) AND 
	min_tick <= '1' WHEN count_s = ZEROS ELSE '0';
END ARCHITECTURE;