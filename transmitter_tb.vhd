library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter_tb is
end transmitter_tb;

architecture rtl of transmitter_tb is
	--signals here
	SIGNAL dataR : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL clockR : STD_LOGIC := '0';
	SIGNAL startR : STD_LOGIC := '0';
	--SIGNAL stopR : std_logic := '0';
	SIGNAL resetR : std_logic := '1';
	SIGNAL o_serialR : std_logic;
	SIGNAL o_activeR : std_logic;
	SIGNAL o_doneR : std_logic;

begin
DUT_TRANSMITTER: ENTITY work.transmitter PORT MAP(
	--transmitter
	data => dataR,		--inputs
	start => startR,
	--stop => stopR,
	clkin => clockR,
	reset => resetR,
	o_serial => o_serialR,	--outputs
	o_active => o_activeR,
	o_done => o_doneR
);

CLKGEN:PROCESS
BEGIN
	WAIT FOR 20 NS;
	clockR <= NOT clockR;

END PROCESS CLKGEN;

STIMULUS:PROCESS
BEGIN
	--change vars here
	dataR <= "10101010";
	startR <= '0';
	--stopR <= '1';
	resetR <= '1';

        WAIT FOR 4 ms;		--change time interval based on baud rate
	dataR <= "00000001";
	startR <= '0';
	--stopR <= '1';
	resetR <= '1';
	
	WAIT FOR 150000 ns;	
	dataR <= "00000011";
	startR <= '0';
	--stopR <= '1';
	resetR <= '1';

	WAIT FOR 150000 ns;		
	dataR <= "00000011";
	startR <= '0';
	--stopR <= '1';
	resetR <= '1';

	WAIT FOR 150000 ns;		
	dataR <= "00000011";
	startR <= '0';
	--stopR <= '1';
	resetR <= '0';

	WAIT FOR 150000 ns;		
	dataR <= "00000011";
	startR <= '1';
	--stopR <= '1';
	resetR <= '0';

END PROCESS STIMULUS;

end rtl;
	