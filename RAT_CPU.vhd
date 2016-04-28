----------------------------------------------------------------------------------
-- Name: 
-- Date: 
-- 
-- Description: Top Level RAT CPU
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAT_CPU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;           
           OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB  : out  STD_LOGIC);
end RAT_CPU;



architecture Behavioral of RAT_CPU is

   --declare all of your components here
   --hint (just copy the entities and change the word entity to component
   --and end with end component
   component prog_rom  
      port (    ADDRESS : in std_logic_vector (9 downto 0); 
             INSTRUCTION : out std_logic_vector (17 downto 0); 
                     CLK : in std_logic);  
   end component;

   component REG_FILE
      port (  WR                : in std_logic;
              CLK               : in std_logic;
              ADRX, ADRY        : in std_logic_vector (4 downto 0);
              DIN               : in std_logic_vector (7 downto 0);
              DX_OUT, DY_OUT    : out std_logic_vector (7 downto 0));
   end component;
   
   component ALU
      port (  CIN       : in STD_LOGIC;
              SEL       : in STD_LOGIC_VECTOR (3 downto 0);
              A         : in STD_LOGIC_VECTOR (7 downto 0);
              B         : in STD_LOGIC_VECTOR (7 downto 0);
              RESULT    : out STD_LOGIC_VECTOR (7 downto 0);
              C         : out STD_LOGIC;
              Z         : out STD_LOGIC);
   end component;
   
   component PC
      port (  CLK       : in STD_LOGIC;
              RST       : in STD_LOGIC;
              PC_LD     : in STD_LOGIC;
              PC_INC    : in STD_LOGIC;
              DIN       : in std_logic_vector (9 downto 0);
              PC_COUNT  : out std_logic_vector (9 downto 0));
   end component;
   
   component CONTROL_UNIT
      port (  CLK           : in   STD_LOGIC;
              C             : in   STD_LOGIC;
              Z             : in   STD_LOGIC;
              RESET         : in   STD_LOGIC;
              OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
              OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
                 
              PC_LD         : out  STD_LOGIC;
              PC_INC        : out  STD_LOGIC;
              PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
              
              RF_WR         : out  STD_LOGIC;
              RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
             
              ALU_OPY_SEL   : out  STD_LOGIC;
              ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
   
              FLG_C_LD      : out  STD_LOGIC;
              FLG_C_SET     : out  STD_LOGIC;
              FLG_C_CLR     : out  STD_LOGIC;
              FLG_Z_CLR     : out  STD_LOGIC;
              FLG_Z_LD      : out  STD_LOGIC;
                 
              RST           : out  STD_LOGIC;
              
              IO_STRB       : out  STD_LOGIC);
    end component;
    
    component Flags
       port ( LD        : in    std_logic;
              DATA_IN   : in    std_logic;
              DATA_OUT  : out   std_logic;
              CLK       : in    std_logic;
              SET       : in    std_logic;
              CLR       : in    std_logic);
    end component;
    
    component Mux_4_1
        port ( A      : in std_logic;
               B      : in std_logic;
               C      : in std_logic;
               D      : in std_logic;
               SEL    : in std_logic_vector(1 downto 0);
               M_OUT  : out std_logic);
    end component;
    
    component Mux_2_1 is
        port ( A      : in std_logic;
               B      : in std_logic;
               SEL    : in std_logic;
               M_OUT  : out std_logic);
    end component;
   -- declare intermediate signals here -----------
   -- these should match the signal names you hand drew on the diagram
      
   signal PC_INC            : std_logic;
   signal PC_LD             : std_logic;
   signal RST               : std_logic;
   signal PC_MUX_SEL        : std_logic_vector (1 downto 0);
   signal DIN               : std_logic_vector (9 downto 0);
   
   signal PC_COUNT          : std_logic_vector (9 downto 0);
         
   signal INSTRUCTION       : std_logic_vector (17 downto 0);
   
   signal DY_OUT            : std_logic_vector (7 downto 0);
   signal DX_OUT            : std_logic_vector (7 downto 0);
   signal ALU_SEL           : std_logic_vector (3 downto 0);
   signal ALU_OPY_SEL       : std_logic;
   signal B                 : std_logic_vector (7 downto 0);

   signal RESULT            : std_logic_vector (7 downto 0);
   signal C                 : std_logic;
   signal Z                 : std_logic;
   
   signal RF_WR             : std_logic;
   signal RF_WR_SEL         : std_logic_vector (1 downto 0);
   signal RF_DIN            : std_logic_vector (7 downto 0);
   
   signal FLG_C_SET         : std_logic;
   signal FLG_C_CLR         : std_logic;
   signal FLG_C_LD          : std_logic;
   signal FLG_Z_LD          : std_logic;
   signal FLG_Z_CLR         : std_logic;
   signal C_FLAG            : std_logic;
   signal Z_FLAG            : std_logic;
   
begin

RST <= RESET;

-- 4:10 Mux for DIN
process (INSTRUCTION, PC_MUX_SEL)
    begin
        case PC_MUX_SEL is
        
        when "00" =>
            DIN <= INSTRUCTION (12 downto 3);
        when "01" =>
            DIN <= "0000000000";
        when "10" =>
            DIN <= "11" & x"FF";
        when "11" =>
            DIN <= "00" & x"00";
        when others =>
            DIN <= "00" & x"00";
        end case;
    end process;
    
-- 4:8 Mux for RF_DIN
process (RESULT, RF_WR_SEL, IN_PORT)
    begin
        case PC_MUX_SEL is
        
        when "00" =>
            RF_DIN <= RESULT;
        when "01" =>
            RF_DIN <= x"00";
        when "10" =>
            RF_DIN <= x"00";
        when "11" =>
            RF_DIN <= IN_PORT;
        when others =>
            RF_DIN <= x"00";
        end case;
    end process;
    
-- 2:8 Mux for ALU B
process (ALU_OPY_SEL, DY_OUT, INSTRUCTION)
    begin
        case ALU_OPY_SEL is
        
        when '0'=>
            B <= DY_OUT;
        when '1' =>
            B <= INSTRUCTION (7 downto 0);
        when others =>
            B <= x"00";
        end case;
    end process;
    
PC_MAP: PC port map ( CLK => CLK,
                      RST => RST,
                      PC_LD => PC_LD,
                      PC_INC => PC_INC,
                      DIN => DIN,
                      PC_COUNT => PC_COUNT);

PROG_MAP: prog_rom port map ( ADDRESS => PC_COUNT,
                              INSTRUCTION => INSTRUCTION,
                              CLK => CLK);
                              
REG_MAP: REG_FILE port map ( WR => RF_WR,
                             CLK => CLK,
                             ADRX => INSTRUCTION (12 downto 8),
                             ADRY => INSTRUCTION (7 downto 3),
                             DIN => RF_DIN,
                             DX_OUT => DX_OUT,
                             DY_OUT => DY_OUT);
                             
ALU_MAP: ALU port map ( CIN => C_FLAG,
                        SEL => ALU_SEL,
                        A => DX_OUT,
                        B => B,
                        RESULT => RESULT,
                        C => C,
                        Z => Z);

C_MAP: Flags port map ( LD => FLG_C_LD,
                         DATA_IN => C,
                         DATA_OUT => C_FLAG,
                         CLK => CLK,
                         SET => FLG_C_SET,
                         CLR => FLG_C_CLR);
                         
Z_MAP: Flags port map ( LD => FLG_Z_LD,
                         DATA_IN => Z,
                         DATA_OUT => Z_FLAG,
                         CLK => CLK,
                         SET => '0',
                         CLR => FLG_Z_CLR);

CU_MAP: CONTROL_UNIT port map (CLK => CLK,
                               C => C_FLAG,
                               Z => Z_FLAG,
                               RESET => RESET,
                               OPCODE_HI_5 => INSTRUCTION (17 downto 13),
                               OPCODE_LO_2 => INSTRUCTION (1 downto 0),
                               PC_LD => PC_LD,
                               PC_INC => PC_INC,
                               PC_MUX_SEL => PC_MUX_SEL,
                               RF_WR => RF_WR,
                               RF_WR_SEL => RF_WR_SEL,
                               ALU_OPY_SEL => ALU_OPY_SEL,
                               ALU_SEL => ALU_SEL,
                               FLG_C_LD => FLG_C_LD,
                               FLG_C_SET => FLG_C_SET,
                               FLG_C_CLR => FLG_C_CLR,
                               FLG_Z_CLR => FLG_Z_CLR,
                               FLG_Z_LD => FLG_Z_LD,
                               RST => RST,
                               IO_STRB => IO_STRB);
end Behavioral;

