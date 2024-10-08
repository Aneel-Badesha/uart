library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter is
	port(data : in std_logic_vector(7 downto 0);
	     start : in std_logic;
	--     stop : in std_logic;
	     clkin : in std_logic;
	     reset : in std_logic;
	     o_serial : out std_logic;
	     o_active : out std_logic;
	     o_done : out std_logic);
end transmitter;

architecture rtl of transmitter is
type state_type is (IDLE, T_START, T_DATA, T_PARITY, T_STOP, T_DONE);
signal state : state_type := IDLE;
signal count : integer := 0;
signal count_p : integer := 0;
signal bitsc: integer range 0 to 7:= 0;
signal parity : std_logic := '0';
signal datahold : std_logic_vector(7 downto 0);
signal done : std_logic := '0';
signal baud : std_logic;
signal clkcounter : integer := 0;
signal clkcount : integer := 50000000/1200;

function to_std_logic(i : in integer) return std_logic is
begin
    if i = 0 then
        return '0';
    end if;
    return '1';
end function;

begin

--	process(clkin)
--	begin
--		if(rising_edge(clkin)) then
----			if (clkcounter < clkcount) then
----				clkcounter <= clkcounter + 1;
----			else
----				clkcounter <= 0;
----				baud <= '1';
----			end if;
----		end if;
--	end process;	

	process(reset,clkin)
	begin	
		if(reset = '1') then
			bitsc <= 0;
			state <= IDLE;
			done <= '0';
			clkcounter <= 0;
			count_p <= 0;
			count <= 0;
		elsif(rising_edge(clkin)) then
			case state is
				when IDLE =>
					bitsc <= 0;
					o_serial <= '0';
					o_active <= '0';
					done <= '0';
					count <= 0;
					count_p <= 0;
					clkcounter <= 0;
					if(start = '0') then
						datahold <= data;
						state <= T_START;
					else 
						state <= IDLE;
					end if;
				when T_START =>
					o_active <= '1';
					o_serial <= '0';
					if(clkcounter < clkcount-1)then
						clkcounter <= clkcounter + 1;
						state <= T_START;
					else
						clkcounter <= 0;
						state <= T_DATA;
					end if;
				when T_DATA =>
					o_serial <= datahold(bitsc);
					if(clkcounter < clkcount -1) then
						clkcounter <= clkcounter +1;
						state <= T_DATA;
					else
						clkcounter <= 0;
					if(bitsc < 7) then
						bitsc <= bitsc + 1;
						state <= T_DATA;
					else
						bitsc <= 0;
						state <= T_PARITY;
					end if;
					end if;
					
				when T_PARITY =>
					if (count < 7) then
						if (datahold(count) = '1') then
							count_p <= count_p + 1;
							count <= count + 1;
						else
							count <= count + 1;
						end if;
						state <= T_PARITY;
					else 
						o_serial <= to_std_logic(count_p mod 2);
						count <= 0;
						count_p <= 0;
						state <= T_STOP;
					end if;

				when T_STOP =>
					o_serial <= '1';
					if(clkcounter < clkcount-1)then
						clkcounter <= clkcounter + 1;
						state <= T_STOP;
					else
						clkcounter <= 0;
						done <= '1';
						state <= T_DONE;
					end if;
					

				when T_DONE =>
					o_active <= '0';
					done <= '1';
					state <= IDLE;

				when others =>
					state <= IDLE;
					
			end case;
		end if;
	end process;
	o_done <= done;
end rtl;