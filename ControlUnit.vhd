----------------------------------------------------------------------------------
-- Name:   
-- Date:  
-- 
-- Description:  Control unit (FSM) for RAT CPU
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CONTROL_UNIT is
    Port ( CLK           : in   STD_LOGIC;
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
end CONTROL_UNIT;

architecture Behavioral of CONTROL_UNIT is

   type state_type is (ST_init, ST_fetch, ST_exec);
   
    signal PS,NS : state_type;
		
	signal sig_OPCODE_7: std_logic_vector (6 downto 0);
begin
   
   -- concatenate the all opcodes into a 7-bit complete opcode for
	-- easy instruction decoding.
   sig_OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;

   sync_p: process (CLK, NS, RESET)
   begin
    if (RESET = '1') then
	   PS <= ST_init;
	elsif (rising_edge(CLK)) then 
       PS <= NS;
 	end if;
   end process sync_p;


   comb_p: process (sig_OPCODE_7, PS, NS, C, Z)
   begin
   
    	-- preset everything to zero --------------------------
      PC_LD <= '0';   PC_MUX_SEL <= "00";   	  
      PC_INC     <= '0';   				
      
      RF_WR <= '0';   RF_WR_SEL  <= "00";   
  
      ALU_OPY_SEL <= '0';  ALU_SEL <= "0000";       			

      FLG_C_SET  <= '0';   FLG_C_CLR   <= '0'; 
      FLG_C_LD   <= '0';   FLG_Z_LD    <= '0';     
	  FLG_Z_CLR  <= '0';

      RST <= '0'; 
      IO_STRB <= '0';
            
   case PS is
      
      -- STATE: the init cycle ------------------------------------
    when ST_init =>
	   RST <= '1';
	   FLG_Z_CLR <= '1';
	   FLG_C_CLR <= '1';
	   NS <= ST_fetch;
						 	
				
      -- STATE: the fetch cycle -----------------------------------
      when ST_fetch => 
         NS <= ST_exec;
         PC_INC <= '1';  -- increment PC
            
            
      -- STATE: the execute cycle ---------------------------------
      when ST_exec => 
           NS <= ST_fetch;           
				
	     case sig_OPCODE_7 is		

		  -- BRN -------------------
              when "0010000" =>   
                    PC_LD <= '1';
		  -- SUB reg-reg  --------
              when "0000110" =>					
                    ALU_SEL <= "0010";
                    RF_WR <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
		  -- IN reg-immed  ------
              when "1100100" | "1100101" | "1100110" | "1100111" =>		                             
                    RF_WR <= '1';
                    RF_WR_SEL <= "11";
		  -- OUT reg-immed  ------
              when "1101000" | "1101001" | "1101010" | "1101011" =>		               
                    IO_STRB <= '1';
		  -- MOV reg-immed  ------
              when "1101100" | "1101101" | "1101110" | "1101111" =>		               
                    ALU_OPY_SEL <= '1';
                    ALU_SEL <= "1110";
                    RF_WR <= '1';
              when others =>		-- for inner case
                  --everything was preset to zero, so that should be the default
                      

            end case; -- inner execute case statement


          when others =>    -- for outer case
               NS <= ST_fetch; 
				 
	    end case;  -- outer init/fetch/execute case
       
   end process comb_p;
   
   
end Behavioral;




