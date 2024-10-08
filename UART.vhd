library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
	port(SW : in std_logic_vector(10 downto 0);
	     KEY : in std_logic_vector(0 downto 0);
	     CLOCK_50 : in std_logic;
	     UART_TXD : out std_logic;
	     UART_CTS : out std_logic;
	     UART_RXD : in std_logic;
	     UART_RTS : out std_logic;
	     LEDG : out std_logic_vector(1 downto 0);
	     LEDR : out std_logic_vector(7 downto 0);
	     LCD_RW : out std_logic;  -- R/W control signal for the LCD
             LCD_EN : out std_logic;  -- Enable control signal for the LCD
             LCD_RS : out std_logic;  -- Whether or not you are sending an instruction or character
             LCD_ON : out std_logic;  -- used to turn on the LCD
             LCD_BLON : out std_logic; -- used to turn on the backlight
             LCD_DATA : out std_logic_vector(7 downto 0));  -- used to send instructions or characters
end UART;

architecture rtl of UART is
--	component baudrgen is
--		PORT (clkin : in std_logic;
--		      clkout : out std_logic);
--   	END component;

	component transmitter is
		PORT (data : in std_logic_vector(7 downto 0);
	     start : in std_logic;
	--     stop : in std_logic;
	     clkin : in std_logic;
	     reset : in std_logic;
	     o_serial : out std_logic;
	     o_active : out std_logic;
	     o_done : out std_logic);
   	END component;
	component receiver is
		PORT (i_serial : in std_logic;
	--     stop : in std_logic;
	     clkin : in std_logic;
	     resetn : in std_logic;
	     o_data : out std_logic_vector(7 downto 0);
	     start : out std_logic);
   	END component;

--	component receiver is
--		PORT (data : in std_logic_vector(7 downto 0);
--		      start : in std_logic;
--	     	      stop : in std_logic;
--	     	      baud : in std_logic;
--	     	      reset : in std_logic;
--	      	      outch : out std_logic_vector(10 downto 0));
--   	END component;

	signal datat : std_logic_vector(10 downto 0);
	signal rstn : std_logic;
	signal baudclk : std_logic;
	SIGNAL dataholder : std_logic_vector(7 downto 0);

begin

--	obj1: baudrgen
--    	port map(clkin => CLOCK_50,
--	     	 clkout => baudclk);

	obj1: transmitter
	port map(data => SW(7 downto 0),
		 start => SW(8),
		 clkin => CLOCK_50,
		 reset => SW(9),
		 o_serial => UART_TXD,
		 o_active => UART_CTS,
		 o_done => LEDG(0));

	obj2: receiver
	port map(i_serial => UART_RXD,
	--     stop : in std_logic;
	     clkin => CLOCK_50,
	     resetn => SW(9),
	     o_data => LEDR,
	     start => UART_RTS);


process(SW,KEY,CLOCK_50)
begin
end process;

--	datat <= SW;	
--	rstn <= KEY(0);

end rtl;

