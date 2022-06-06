LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
------------------------------------------------------------------
ENTITY univ_bin_counter IS
	GENERIC	(	N			:	INTEGER := 28);
					
	PORT		(	clk		:	IN		STD_LOGIC;
					rst		:	IN		STD_LOGIC;
					ena		:	IN		STD_LOGIC;
					syn_clr	:	IN		STD_LOGIC;
					max_count: 	IN 	STD_LOGIC_VECTOR(N-1 DOWNTO 0);
					up			:	IN		STD_LOGIC;
					max_tick :	OUT 	STD_LOGIC;
					--min_tick :	OUT	STD_LOGIC;
					counter	: 	OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END ENTITY;
------------------------------------------------------------------
ARCHITECTURE rtl OF univ_bin_counter IS
	CONSTANT ONES			:	UNSIGNED(N-1 DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED(N-1 DOWNTO 0)	:=	(OTHERS => '0');
	SIGNAL count_s			:	UNSIGNED(N-1 DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED(N-1 DOWNTO 0);
	SIGNAL max_tick_s		:	STD_LOGIC;
	SIGNAL max_count_s 	:	UNSIGNED(N-1 DOWNTO 0);
BEGIN
	max_count_s <= 	UNSIGNED(max_count);
	
	count_next	<=		(OTHERS =>	'0')	WHEN 	syn_clr='1'						ELSE
							(OTHERS =>	'0')	WHEN	max_tick_s='1'					ELSE
							count_s + 1			WHEN 	(ena ='1' AND up='1')		ELSE
							count_s - 1			WHEN 	(ena ='1' AND up='0')		ELSE
							count_s;
	PROCESS(clk,rst)
		VARIABLE temp	:	UNSIGNED(N-1 DOWNTO 0);
	BEGIN
		IF(rst='1') THEN
			temp:=	(OTHERS =>	'0');
		ELSIF (rising_edge(clk)) THEN
			IF (ena='1') THEN
				temp	:=	count_next;
			END IF;
		END IF;
		counter	<=	STD_LOGIC_VECTOR(temp);
		count_s	<=	temp;
	END PROCESS;
	max_tick <= max_tick_s;
	max_tick_s <=	'1'	WHEN count_s = max_count_s ELSE '0';
	--min_tick <=	'1'	WHEN count_s = ZEROS ELSE '0';
END ARCHITECTURE;	