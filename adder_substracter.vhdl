library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity principal is
Port ( 	clk : in  STD_LOGIC;
   a : in  STD_LOGIC_VECTOR (3 downto 0);
   b : in  STD_LOGIC_VECTOR (3 downto 0);
	sel : in std_logic_vector (1 downto 0);
	s : inout  std_logic_vector(4 downto 0);
   n : out std_logic;      	 
	An : out  std_logic_vector(3 downto 0);
			  
	Seg : out  STD_LOGIC_VECTOR(6 downto 0));

end principal;

architecture Behavioral of principal is

Signal Cont:integer range 0 to 3;

Signal Contador1ms:integer range 0 to 50000;

Signal MUX: std_logic_vector(3 downto 0);
Signal BCD: std_logic_vector(7 downto 0);
signal c: STD_LOGIC_VECTOR (2 downto 0);

begin


process (sel,a,b)
begin

	 if (sel="00") then
s(0)<=a(0) xor b(0);
c(0)<=(a(0) and b(0));
s(1)<=(a(1) xor b(1)) xor c(0);
c(1)<=(a(1) and b(1)) or (c(0) and (a(1) xor b(1)));
s(2)<=(a(2) xor b(2)) xor c(1);
c(2)<=(a(2) and b(2)) or (c(1) and (a(2) xor b(2)));
s(3)<=(a(3) xor b(3)) xor c(2);
s(4)<=(a(3) and b(3)) or (c(2) and (a(3) xor b(3)));
	n<='0';
	end if;	
	
if (sel= "10") then

	n<='0';	
		if (a >= b) then

s(0)<=a(0) xor b(0);
c(0)<=(b(0) and not a(0));
s(1)<=(a(1) xor b(1)) xor c(0);
c(1)<=(b(1) and not a(1)) or (c(0) and not a(1)) or (b(1) and c(0));
s(2)<=(a(2) xor b(2)) xor c(1);
c(2)<=(b(2) and not a(2)) or (c(1) and not a(2)) or (b(2) and c(1));
s(3)<=(a(3) xor b(3)) xor c(2);
s(4)<=(b(3) and not a(3)) or (c(2) and not a(3)) or (b(3) and c(2));

		elsif a < b  then
n<='1';
s(0)<=a(0) xor b(0);
c(0)<=(a(0) and not b(0));
s(1)<=(a(1) xor b(1)) xor c(0);
c(1)<=(a(1) and not b(1)) or (c(0) and not b(1)) or (a(1) and c(0));
s(2)<=(a(2) xor b(2)) xor c(1);
c(2)<=(a(2) and not b(2)) or (c(1) and not b(2)) or (a(2) and c(1));
s(3)<=(a(3) xor b(3)) xor c(2);
s(4)<=(a(3) and not b(3)) or (c(2) and not b(3)) or (a(3) and c(2));
 
		else
		s<="00000";
		end if;	
end if;
end process;

--contador 50000 ciclos


Contador1ms<=0 when Contador1ms=50000 else
Contador1ms + 1 when clk'event and clk='1';


--contador de 0 a 3

cont<= cont + 1 when Contador1ms=49999 and clk'event and clk='1';

--MuX

MUX <= BCD(3 downto 0) when cont=0 else

       BCD(7 downto 4) when cont=1 else
       "0000";

--decod de 2 a 4 


An<= "0111" when cont=0 else
     "1011" when cont=1 else
	  "1101" when cont=2 else
	  "1110";

--Bin a 7 seg

Seg<=   "0000001" when MUX="0000" else --0
	  	"1001111" when MUX="0001" else --1		
	"0010010" when MUX="0010" else --2		
	"0000110" when MUX="0011" else --3		
	"1001100" when MUX="0100" else --4		
	"0100100" when MUX="0101" else --5		
	"0100000" when MUX="0110" else --6		
	"0001111" when MUX="0111" else --7		
	"0000000" when MUX="1000" else --8		
	"0001100"; --9

--Conversor bin a bcd

Process(s)

variable z:std_logic_vector(12 downto 0);

Begin 

for i in 0 to 12 loop
z(i):='0';
end loop;

z(7 downto 3):= s;

for i in 0 to 1 loop

if z(8 downto 5)> 4 then 
z(8 downto 5):= z(8 downto 5) + 3;
end if;

if z(12 downto 9)> 4 then
z(12 downto 9) := z(12 downto 9) + 3;
end if;
z(12 downto 1) := z(11 downto 0);
end loop;
BCD<= z(12 downto 5);
end process;


end Behavioral;

