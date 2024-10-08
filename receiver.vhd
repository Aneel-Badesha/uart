library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity receiver is
	port(i_serial : in std_logic;
	--     stop : in std_logic;
	     clkin : in std_logic;
	     resetn : in std_logic;
	     o_data : out std_logic_vector(7 downto 0);
	     start : out std_logic);
end receiver;

architecture rtl of receiver is
type state_type is (IDLE, T_START, T_DATA, T_STOP, T_DONE);
signal state : state_type := IDLE;
signal count : integer := 0;
signal count_p : integer := 0;
signal bitsc: integer range 0 to 7:= 0;
signal parity : std_logic := '0';
signal datahold : std_logic_vector(7 downto 0) := (others => '0');
signal done : std_logic := '0';
signal baud : std_logic;
signal clkcounter : integer := 0;
signal clkcount : integer := 50000000/1200;
signal r_data : std_logic;
signal r_data_r : std_logic;
signal sigstart : std_logic;

function to_std_logic(i : in integer) return std_logic is
begin
    if i = 0 then
        return '0';
    end if;
    return '1';
end function;

begin	process(clkin)
	begin
		if(rising_edge(clkin)) then
			r_data_r <= i_serial;
			r_data <= r_data_r;
		end if;
	end process;

	process(clkin, resetn)
	begin	
		if(resetn = '1') then
			bitsc <= 0;
			state <= IDLE;
			clkcounter <= 0;
		elsif(rising_edge(clkin)) then
--			if (clkcounter < clkcount) then
--				clkcounter <= clkcounter + 1;
--			else
--				clkcounter <= 0;
--				baud <= '1';
--			end if;
--		end if;
--	end process;	

--	process(reset,start,stop,data)
--	begin	
--		if(reset = '1') then
--			bitsc <= 0;
--			state <= IDLE;
--			o_serial <= '0';
--			o_active <= '0';
--			done <= '0';
--			count <= 0;
--			count_p <= 0;
--			
--		elsif(rising_edge(CLOCK_50)) then
			case state is
				when IDLE =>
--					bitsc <= 0;
--					o_serial <= '0';
--					o_active <= '0';
--					done <= '0';
--					count <= 0;
--					count_p <= 0;
					sigstart <= '0';
					if(r_data = '0') then
						state <= T_START;
					else 
						state <= IDLE;
					end if;
				when T_START =>
					if(clkcounter = (clkcount-1)/2)then
						if(r_data = '0') then
						clkcounter <= 0;
						state <= T_DATA;
					else
						state <= IDLE;
					end if;
					ELSE
						clkcounter <= clkcounter +1;
						state <= T_START;
					end if;
				when T_DATA =>
					if(clkcounter < clkcount -1) then
						clkcounter <= clkcounter +1;
						state <= T_DATA;
					else
						clkcounter <= 0;
						datahold(bitsc) <= r_data;
					if(bitsc < 7) then
						bitsc <= bitsc + 1;
						state <= T_DATA;
					else
						bitsc <= 0;
						state <= T_STOP;
					end if;
					end if;
					
--				when T_PARITY =>
--					if (count < 7) then
--						if (datahold(count) = '1') then
--							count_p <= count_p + 1;
--							count <= count + 1;
--						else
--							count <= count + 1;
--						end if;
--						state <= T_PARITY;
--					else 
--						o_serial <= to_std_logic(count_p mod 2);
--						count <= 0;
--						count_p <= 0;
--						state <= T_STOP;
--					end if;

				when T_STOP =>
					if(clkcounter < clkcount-1)then
						clkcounter <= clkcounter + 1;
						state <= T_STOP;
					else
						clkcounter <= 0;
						sigstart <= '1';
						state <= T_DONE;
					end if;
					

				when T_DONE =>
					sigstart <= '0';
					state <= IDLE;

				when others =>
					state <= IDLE;
					
			end case;
		end if;
	end process;
	start <= sigstart;
	o_data <= datahold;
end rtl;
