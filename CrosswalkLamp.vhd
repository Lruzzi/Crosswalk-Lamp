library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity crosswalk_lamp is
  port (
    reset : in std_logic;
    clock : in std_logic;
    tombol : inout std_logic
  ) ;
end crosswalk_lamp ; 

architecture arch of crosswalk_lamp is

    constant waktu_menyebrang : integer := 20; --limit waktu saat menyebrang
    constant waktu_tunggu : integer := 5; --limit waktu tunggu sesaat ada yang menekan tombol

    signal timeout : std_logic := '0';
    signal trigger_20 : std_logic := '0';
    signal trigger_5 : std_logic := '0';
    signal trigger_0 :std_logic := '0';

    type state is (menyebrang, tidak_menyebrang, tunggu);
    signal PS, NS : state;

    type lampu is (merah, kuning, hijau);
    signal lampu_jalanRaya, lampu_penyebrang : lampu;

begin

    sync_proc : process (reset, timeout, clock, NS)
    begin
        if timeout = '1' and rising_edge(clock) then PS <= NS;
        elsif reset = '1' then PS <= tidak_menyebrang;    
        end if;
    end process sync_proc;

    comb_proc : process (tombol, PS, timeout)
    begin
        trigger_20 <= '0';
        trigger_5 <= '0';
        trigger_0 <= '0';
        case PS is
            when tidak_menyebrang =>
                lampu_jalanRaya <= hijau;
                lampu_penyebrang <= merah;
                if (tombol = '1') 
                    then NS <= tunggu;
                    trigger_5 <= '1';
                elsif (tombol = '0') then NS <= tidak_menyebrang;
                end if;

            when tunggu =>
                lampu_jalanRaya <= kuning;
                lampu_penyebrang <= kuning;

                trigger_5 <= '1';
                NS <= menyebrang;
                

            when menyebrang =>
                lampu_jalanRaya <= merah;
                lampu_penyebrang <= hijau;

                trigger_20 <= '1';
                NS <= tidak_menyebrang; 
                tombol <= '0';
                
            end case;
            end process comb_proc;

        timer : process (trigger_20, trigger_5, clock)
            variable count : integer;
        begin
            timeout   <= '0';
            count := 0;
            if trigger_5 = '1' then
                if rising_edge(clock) then
					assert (count = -1) report "count = " & integer'image(count) severity error;
					count := count + 1;
					if (count = waktu_tunggu) then
						timeout <= '1';
						count := 0;
					end if;
				end if;
            elsif trigger_20 = '1' then
                if rising_edge(clock) then
					assert (count = -1) report "count = " & integer'image(count) severity error;
					count := count + 1;
					if (count = waktu_menyebrang) then
						timeout <= '1';
						count := 0;
					end if;
				end if;
            elsif trigger_0 = '1' then timeout <= '1';
            end if;
            end process timer;
                
                    

end architecture ;