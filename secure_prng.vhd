-- ========================================
-- Fichier: secure_prng.vhd
-- Description: Générateur de clé pseudo-aléatoires sécurisé
-- Auteur: Votre nom
-- Date: 2024
-- =========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity secure_prng is
    Generic (
        SEED_WIDTH : integer := 128;   -- Largeur de la graine (128 bits)
        OUTPUT_WIDTH : integer := 128  -- Largeur de sortie (clé de 128 bits)
    );
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        enable      : in  STD_LOGIC;
        seed        : in  STD_LOGIC_VECTOR(SEED_WIDTH-1 downto 0);
        load_seed   : in  STD_LOGIC;
        key_out     : out STD_LOGIC_VECTOR(OUTPUT_WIDTH-1 downto 0);
        key_valid   : out STD_LOGIC
    );
end secure_prng;

architecture Behavioral of secure_prng is
    
    -- Registres LFSR
    signal lfsr_reg : STD_LOGIC_VECTOR(SEED_WIDTH-1 downto 0);
    signal feedback : STD_LOGIC;
    signal counter  : integer range 0 to OUTPUT_WIDTH := 0;
    signal key_buffer : STD_LOGIC_VECTOR(OUTPUT_WIDTH-1 downto 0);
    signal valid_internal : STD_LOGIC := '0';
    
    -- Polynôme primitif pour LFSR 128-bit
    -- x^128 + x^29 + x^27 + x^2 + 1
    -- Positions des taps : 128, 29, 27, 2
    
begin

    -- Calcul du feedback (XOR des positions de tap)
    feedback <= lfsr_reg(127) xor lfsr_reg(28) xor lfsr_reg(26) xor lfsr_reg(1);

    -- Processus principal du PRNG
    main_process: process(clk, reset)
    begin
        if reset = '1' then
            -- Initialisation avec une valeur non-nulle
            lfsr_reg <= (0 => '1', others => '0');
            key_buffer <= (others => '0');
            counter <= 0;
            valid_internal <= '0';
            
        elsif rising_edge(clk) then
            
            -- Chargement d'une nouvelle graine
            if load_seed = '1' then
                -- Vérifier que la graine n'est pas nulle
                if seed = (seed'range => '0') then
                    lfsr_reg <= (0 => '1', others => '0');  -- Graine par défaut
                else
                    lfsr_reg <= seed;
                end if;
                counter <= 0;
                valid_internal <= '0';
                key_buffer <= (others => '0');
                
            elsif enable = '1' then
                -- Décalage LFSR avec feedback
                lfsr_reg <= lfsr_reg(SEED_WIDTH-2 downto 0) & feedback;
                
                -- Accumulation des bits pour former la clé
                key_buffer <= key_buffer(OUTPUT_WIDTH-2 downto 0) & feedback;
                
                -- Compteur pour générer une clé complète
                if counter = OUTPUT_WIDTH-1 then
                    counter <= 0;
                    valid_internal <= '1';  -- Clé complète générée
                else
                    counter <= counter + 1;
                    valid_internal <= '0';
                end if;
            else
                valid_internal <= '0';
            end if;
            
        end if;
    end process;
    
    -- Sorties
    key_out <= key_buffer;
    key_valid <= valid_internal;

end Behavioral;
