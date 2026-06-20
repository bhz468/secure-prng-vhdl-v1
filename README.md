# Secure PRNG — VHDL Version 1

A secure pseudo-random number generator (PRNG) implemented in VHDL using a 128-bit Linear Feedback Shift Register (LFSR).

## Files

| File | Description |
|------|-------------|
| `secure_prng.vhd` | Main PRNG entity using a 128-bit LFSR with primitive polynomial x¹²⁸ + x²⁹ + x²⁷ + x² + 1 |
| `tb_secure_prng.vhd` | Testbench — verifies key generation, seed loading, and reproducibility |

## Features

- 128-bit seed input with zero-seed protection
- 128-bit key output with valid signal
- Synchronous reset and seed loading

## Simulation

```bash
vcom secure_prng.vhd
vcom tb_secure_prng.vhd
vsim tb_secure_prng
```
