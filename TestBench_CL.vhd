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
    signal counter_clock : integer := 0;
	
begin
  test : crosswalk_lamp port map (clock, tombol, keadaan);

  uut : process
      begin
          clock <= '0';
          wait for clock_PERIOD;
          clock <= '1';
          counter_clock <= counter_clock + 1;
          wait for clock_PERIOD;

          if(counter_clock = 26) then
            tombol <= '1';

          elsif (counter_clock = 27) then
            tombol <= '0';
            assert keadaan = "10" report "Output Salah" severity warning;

          --tunggu
          elsif(counter_clock = 29) then
            tombol <= '1';
          elsif(counter_clock = 30) then

          --menyebrang
          elsif (counter_clock = 35) then
            tombol <= '0';
            assert keadaan = "11" report "Output Salah" severity warning;

          elsif (counter_clock = 48) then 
            tombol <= '1';

          elsif(counter_clock = 54) then 
            tombol <= '0';

          elsif(counter_clock = 55) then
            tombol <= '1';
          elsif (counter_clock = 56) then
            assert keadaan = "01" report "Output Salah" severity warning;

          elsif(counter_clock = 102) then
            wait;
          end if;

	end process;
end architecture ;