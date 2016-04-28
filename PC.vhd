----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2016 09:22:49 AM
-- Design Name: 
-- Module Name: PC - PC_dtfl
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
entity PC is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           DIN : in std_logic_vector(9 downto 0);
           PC_COUNT : out std_logic_vector(9 downto 0));
end PC;

architecture PC_dtfl of PC is
begin

CLOCK: process (CLK, RST, PC_LD, PC_INC, DIN)
    variable ln : std_logic_vector(9 downto 0) := "00" & x"01";
    begin
        if (RST = '1') then
            ln := (others => '0');
        elsif (rising_edge(CLK)) then
            if (PC_LD = '1') then
                ln := DIN;
            elsif (PC_INC = '1') then
                ln := ln + 1;
            end if;
        end if;
        
        PC_COUNT <= ln;
    end process CLOCK;
    
end PC_dtfl;
