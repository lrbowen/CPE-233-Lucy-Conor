----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2016 09:40:22 AM
-- Design Name: 
-- Module Name: REG_FILE - Reg_dtfl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 32 x 8
entity REG_FILE is
    Port ( WR : in std_logic;
           CLK : in std_logic;
           ADRX, ADRY : in std_logic_vector(4 downto 0);
           DIN : in std_logic_vector(7 downto 0);
           DX_OUT, DY_OUT : out std_logic_vector(7 downto 0)
           );
end REG_FILE;

architecture Reg_dtfl of REG_FILE is
    type reg is array(0 to 31) of std_logic_vector(7 downto 0);
    signal registers : reg;
begin

WRITE: process(CLK, WR)
    begin
        if (rising_edge(CLK)) then
            if (WR = '1') then
                registers(conv_integer(ADRX)) <= DIN;
            end if;
        end if;
    end process WRITE;

DX_OUT <= registers(conv_integer(ADRX));
DY_OUT <= registers(conv_integer(ADRY));

end Reg_dtfl;
