
-- ========================================
-- Fichier: tb_secure_prng.vhd
-- Description: Testbench pour le générateur PRNG
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity tb_secure_prng is
end tb_secure_prng;

architecture Behavioral of tb_secure_prng is
    
    -- Constantes
    constant SEED_WIDTH : integer := 128;
    constant OUTPUT_WIDTH : integer := 128;
    constant CLK_PERIOD : time := 10 ns;
    
    -- Signaux de test
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal seed : STD_LOGIC_VECTOR(SEED_WIDTH-1 downto 0);
    signal load_seed : STD_LOGIC := '0';
    signal key_out : STD_LOGIC_VECTOR(OUTPUT_WIDTH-1 downto 0);
    signal key_valid : STD_LOGIC;