library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity test is
end test;

architecture test_arch of test is
component ps2_port
port (clk:in std_logic; ps2_clk: in std_logic; data : in std_logic_vector (0 to 7);
ps2_dataDevice: out std_logic;
ps2_dataHost: out std_logic;
setCodeDevice: out std_logic_vector (0 to 10);
setCodeHost: out std_logic_vector (0 to 11);
breakCodeDevice: out std_logic_vector (0 to 18);
breakCodeHost: out std_logic_vector (0 to 19)
);

end component;
signal clk:std_logic;
signal ps2_clk:std_logic;
signal data: std_logic_vector(0 to 7);
signal ps2_dataDevice: std_logic;
signal ps2_dataHost: std_logic;
signal setCodeDevice: std_logic_vector(0 to 10);
signal setCodeHost: std_logic_vector(0 to 11);
signal breakCodeDevice: std_logic_vector (0 to 18);
signal breakCodeHost : std_logic_vector (0 to 19);
file file_handler : text open read_mode is "keys.txt";
procedure read_line_proc(
	signal rline : out std_logic_vector (0 to 7)) is
	variable row : line;
	variable v_data_read : std_logic_vector (0 to 7);
	begin
		if(not endfile(file_handler)) then
		readline(file_handler, row);
		read(row, v_data_read);
		rline <= v_data_read;
		end if;
end read_line_proc;

begin
gate0:ps2_port
port map(clk,ps2_clk,data,ps2_dataDevice,ps2_dataHost,
setCodeDevice,setCodeHost,breakCodeDevice,breakCodeHost);
Clkproc:process
	variable i:integer :=0;
	begin
		
		Clk<='1';
		wait for 50 us;
		if (i=10) then
		Clk<='0';
		wait for 300 us;
		else
		clk<='0';
		wait for 50 us;
		end if;
	i:=i+1;
	if(i>10) then
	i:=0;
	end if;
	end process;
Ps_2Clkproc:process
	variable i:integer :=0;
	begin
		
		ps2_clk<='1';
		wait for 50 us;
		if(i=0) then
		ps2_clk<='0';
		wait for 100 us;
		else
		ps2_clk<='0';
		wait for 50 us;
		end if;
	i:=i+1;
	if(i>12) then
	i:=0;
	end if;
	end process;
ReadFile: process
begin 
	read_line_proc(data);
	wait for 1350 us;
end process;
end test_arch;