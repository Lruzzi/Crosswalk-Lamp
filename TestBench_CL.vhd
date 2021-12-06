library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity TesTBench_CL is
end TesTBench_CL; 

architecture arch of TesTBench_CL is
    component crosswalk_lamp is
        port (
          clock : in std_logic;
          tombol : in std_logic;
          keadaan : out std_logic_vector (1 downto 0)
        );
      end component; 
    signal clock : std_logic;
    signal tombol : std_logic := '0';
    signal keadaan : std_logic_vector (1 downto 0);
    constant clock_PERIOD : time := 0.1 ns;
    signal counter : integer := 0;
	
begin
  test : crosswalk_lamp port map (clock, tombol, keadaan);

  uut : process
      begin
          clock <= '0';
          wait for clock_PERIOD;
          clock <= '1';
          counter <= counter + 1;
          wait for clock_PERIOD;

          if(counter = 26) then
            tombol <= '1';
          --tunggu
          elsif(counter = 31) then
            tombol <= '0';
          
          --menyebrang
          elsif (counter = 46) then 
            tombol <= '1';

          elsif(counter = 51) then 
            tombol <= '0';

          
          elsif(counter = 52) then
            tombol <= '1';

          elsif(counter = 76) then
            wait;
          end if;
	end process;
end architecture ;