library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity cache_datapath is port(
    clk: in std_logic;
    read,write: in std_logic;
    writeData: in std_logic_vector(31 downto 0);
    fullAddress: in std_logic_vector(9 downto 0);
    outData:out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of cache_datapath is

    component MissHitLogic is port (
        tag: in std_logic_vector (3 downto 0);
        w0: in std_logic_vector (4 downto 0);
        w1: in std_logic_vector (4 downto 0);
        hit:out std_logic;
        w0_valid: out std_logic;
        w1_valid: out std_logic);
    end component;
    component controller is port (
        clk: in std_logic;
        hit: in std_logic;
        read: in std_logic;
        write: in std_logic;
        cache_dataReady: in std_logic;
        mem_dataReady: in std_logic;
        w_validNo: std_logic_vector(1 downto 0);
        reset_n: out std_logic;
        cache_wren: out std_logic;
        mem_wren: out std_logic;
        invalidate: out std_logic;
        enableDSC: out std_logic;
        resetDSC: out std_logic);
    end component;
    component DataArray is port (
        clk: in std_logic;
        address: in std_logic_vector (5 downto 0);
        wren: in std_logic;
        wrdata: in std_logic_vector (31 downto 0);
        data: out std_logic_vector (31 downto 0));
    end component;
    component DataSelectionCircuit is port (
        clk: in std_logic;
        address: in std_logic_vector(5 downto 0);
        w_validNo: in std_logic_vector(1 downto 0);
        enable: in std_logic;
        reset: in std_logic;
        w: out std_logic
        );
    end component;
    component TagValidArray is port (
        clk: in std_logic;
        reset_n: in std_logic;
        address: in std_logic_vector (5 downto 0);
        wren: in std_logic;
        invalidate: in std_logic;
        wrdata: in std_logic_vector (3 downto 0);
        output: out std_logic_vector (4 downto 0));
    end component;
    component memory is
        port(
            clk, mem_wren:in STD_LOGIC;
             address:in STD_LOGIC_VECTOR(9 downto 0);
             data_in:in STD_LOGIC_VECTOR(31 downto 0);
             data_out:out STD_LOGIC_VECTOR(31 downto 0);
             mem_dataReady:out STD_LOGIC := '0'
         );
    end component;
    component decoder is
      port (
        input: in std_logic;
        output: out std_logic_vector(1 downto 0);
        control: in std_logic
      );
  end component;
    component mux is
      port (
        input: in std_logic_vector(1 downto 0);
        output: out std_logic;
        control: in std_logic
      );
  end component;
  component cacheDataInSelector is
    port (
      read: in std_logic;
      write: in std_logic;
      ramData: in std_logic_vector(31 downto 0);
      inData: in std_logic_vector(31 downto 0);
      cacheIn: out std_logic_vector(31 downto 0)
    );
    end component;

    signal reset_n,w,resetDSC,enableDSC,wNo,hit,mem_wren,cache_wren,invalidate,mem_dataReady: std_logic;
    signal reset_nNo,wrenNo,invalidateNo,w_validNo: std_logic_vector(1 downto 0);
    signal address: std_logic_vector(5 downto 0);
    signal outputTVA1,outputTVA2: std_logic_vector(4 downto 0);
    signal tag: std_logic_vector(3 downto 0);
    signal w_valid: std_logic;
    signal notW: std_logic;
    signal cache_dataReady: std_logic:='1';
    signal cacheIn: std_logic_vector(31 downto 0);
    signal DA1Out: std_logic_vector(31 downto 0);
    signal DA2Out: std_logic_vector(31 downto 0);
    signal RamOut: std_logic_vector(31 downto 0);
    signal test: std_logic_vector(1 downto 0);


begin

    w_valid <= (w_validNo(0) nor w) or (w_validNo(1) and w);
    tag <= fullAddress(9 downto 6);
    address <= fullAddress(5 downto 0);
    notW <= not w;
    TagValidArrayNo1: TagValidArray port map (clk,reset_nNo(0),address,wrenNo(0),invalidateNo(0),tag,outputTVA1);
    TagValidArrayNo2: TagValidArray port map (clk,reset_nNo(1),address,wrenNo(1),invalidateNo(1),tag,outputTVA2);
    DataArrayNo1: DataArray port map (clk,address,wrenNo(0),cacheIn,DA1Out);
    DataArrayNo2: DataArray port map (clk,address,wrenNo(1),cacheIn,DA2Out);
    MRU: DataSelectionCircuit port map (clk,address,w_validNo,enableDSC,resetDSC,w);
    MissHit: MissHitLogic port map (tag,outputTVA1,outputTVA2,hit,w_validNo(0),w_validNo(1));
    Ram: memory port map (clk,mem_wren,fullAddress,writeData,RamOut,mem_dataReady);
    cache_controller: controller port map (clk,hit,read,write,cache_dataReady,mem_dataReady,w_validNo,reset_n,cache_wren,mem_wren,invalidate,enableDSC,resetDSC);
    reset_n_decoder: decoder port map(reset_n,reset_nNo(1 downto 0),w);
    WREN_decoder: decoder port map(cache_wren,wrenNo(1 downto 0),w);
    invalidate_decoder: decoder port map (invalidate,invalidateNo(1 downto 0),notW);
    cacheDataSelect: cacheDataInSelector port map (read,write,RamOut,writeData,cacheIn);
    DataOutSelect : process(clk)
    begin
        if rising_edge(clk) then
            if hit = '1' then
                if w_validNo(0) = '1' then
                    outData <= DA1Out;
                elsif w_validNo(1) = '1' then
                    outData <= DA2Out;
                end if;
            else
                outData <= RamOut;
              end if;
        end if;
    end process;

end architecture;
