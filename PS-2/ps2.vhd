library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity ps2DeviceToHost is
port (clk:in std_logic; data : in std_logic_vector (0 to 7);
ps2_data: out std_logic;
setCodeDevice : out std_logic_vector (0 to 10);
breakCodeDevice:out std_logic_vector(0 to 18));
end ps2DeviceToHost;

architecture ps2DeviceToHost_arch of ps2DeviceToHost is
file test_vector      : text open write_mode is "setCodes.txt";
file test_vector2      : text open write_mode is "breakCodes.txt";
constant f0: std_logic_vector (0 to 7):=('1','1','1','1','0','0','0','0');
begin
process(clk)
Variable row : line;
variable row2 : line;
variable i:integer :=0;
variable setCode: std_logic_vector (0 to 10);
variable breakCode:std_logic_vector (0 to 18);
begin
	if (falling_edge(clk)) then
		if(i=0) then
			setCode(0):='0';
			ps2_data<='0';
		elsif (i>0 and i<9) then
			setCode(i):=data(8-i);
			ps2_data<=data(8-i);
		elsif (i=9) then
			ps2_data<=not(data(7) xor data(6) xor data(5) xor
			data(4) xor data(3) xor data(2) xor data(1) xor
			data(0));
			setCode(i):=not(data(7) xor data(6) xor data(5) xor
			data(4) xor data(3) xor data(2) xor data(1) xor
			data(0));
		elsif(i=10) then
			setCode(10):='1';
			ps2_data<='1';
			setCodeDevice<=setCode;
			write(row, setCode);
  			writeline(test_vector ,row);
			breakCode:=f0&setCode;
			breakCodeDevice<=breakCode;
			write(row2, breakCode);
  			writeline(test_vector2 ,row2);
		end if;
	i:=i+1;
		if(i>10) then
		i:=0;
		end if;
	end if;
end process; 
end ps2DeviceToHost_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity ps2HostToDevice is
port (ps2_clk:in std_logic; data : in std_logic_vector (0 to 7);
ps2_data: out std_logic;
setCodeHost : out std_logic_vector (0 to 11);
breakCodeHost:out std_logic_vector (0 to 19));
end ps2HostToDevice;

architecture ps2HostToDevice_arch of ps2HostToDevice is
file test_vector      : text open write_mode is "setCodes.txt";
file test_vector2      : text open write_mode is "breakCodes.txt";
constant f0: std_logic_vector (0 to 7):=('1','1','1','1','0','0','0','0');
begin
process(ps2_clk)
Variable row : line;
Variable row2: line;
variable i,i2:integer :=0;
variable setCodeH: std_logic_vector (0 to 11);
variable breakCodeH: std_logic_vector (0 to 19);
begin
	if (falling_edge(ps2_clk)) then
		if(i2>0)then
			if(i=0) then
				setCodeH(0):='0';
				ps2_data<='0';
			elsif (i>0 and i<9) then
				setCodeH(i):=data(8-i);
				ps2_data<=data(8-i);
			elsif (i=9) then
				ps2_data<=not(data(7) xor data(6) xor data(5) xor
				data(4) xor data(3) xor data(2) xor data(1) xor
				data(0));
				setCodeH(i):=not(data(7) xor data(6) xor data(5) xor
				data(4) xor data(3) xor data(2) xor data(1) xor
				data(0));
			elsif(i=10) then
				ps2_data<='1';
				setCodeH(i):='1';
			elsif(i=11) then
				ps2_data<='0';
				setCodeH(i):='0';
				setCodeHost<=setCodeH;
				write(row, setCodeH);
  				writeline(test_vector ,row);
				breakCodeH:=f0&setCodeH;
				breakCodeHost<=breakCodeH;
				write(row2, breakCodeH);
  				writeline(test_vector2 ,row2);
			end if;
		
		i2:=i+1;
		i:=i+1;
		if(i>11) then
			i:=0;
			i2:=0;
		end if;
		else
			i2:=i+1;
		end if;
	end if;
end process; 
end ps2HostToDevice_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
entity writeToFile is
port (setCodeDevice: in std_logic_vector (0 to 10);
setCodeHost: in std_logic_vector (0 to 11);
breakCodeDevice: in std_logic_vector (0 to 18);
breakCodeHost: in std_logic_vector (0 to 19));
end writeToFile;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity ps2_port is
port (clk:in std_logic; ps2_clk: in std_logic; data : in std_logic_vector (0 to 7);
ps2_dataDevice: out std_logic;
ps2_dataHost: out std_logic;
setCodeDevice: out std_logic_vector (0 to 10);
setCodeHost: out std_logic_vector (0 to 11);
breakCodeDevice: out std_logic_vector (0 to 18);
breakCodeHost: out std_logic_vector (0 to 19)
);
end ps2_port;

architecture ps2_port_arch of ps2_port is
component ps2DeviceToHost
port (clk:in std_logic; data : in std_logic_vector (0 to 7);
ps2_data: out std_logic;
setCodeDevice : out std_logic_vector (0 to 10);
breakCodeDevice:out std_logic_vector (0 to 18));
end component;
component ps2HostToDevice
port (ps2_clk:in std_logic; data : in std_logic_vector (0 to 7);
ps2_data: out std_logic;
setCodeHost : out std_logic_vector (0 to 11);
breakCodeHost:out std_logic_vector (0 to 19));
end component;
signal settCodeHost: std_logic_vector(0 to 11);
signal settCodeDevice: std_logic_vector(0 to 10);
signal breakkCodeHost: std_logic_vector(0 to 19);
signal breakkCodeDevice: std_logic_vector(0 to 18);
signal pss2_dataHost:std_logic;
signal pss2_dataDevice:std_logic;
begin
gate0:ps2DeviceToHost
port map(clk,data,pss2_dataDevice,settCodeDevice,breakkCodeDevice);
ps2_dataDevice<=pss2_dataDevice;
setCodeDevice<=settCodeDevice;
breakCodeDevice<=breakkCodeDevice;
gate1:ps2HostToDevice
port map(ps2_clk,data,pss2_dataHost,settCodeHost,breakkCodeHost);
ps2_dataHost<=pss2_dataHost;
setCodeHost<=settCodeHost;
breakCodeHost<=breakkCodeHost;
end ps2_port_arch;
