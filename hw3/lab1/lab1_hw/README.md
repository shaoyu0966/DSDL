# Full Adders

### Features
- `adder_rtl`: adder without delay, register-transfer level modeling
- `rca_gl`: ripple-carry adder, gate level modeling
- `cla_gl`: carry-lookahead adder, gate level modeling

### Usage

- Derive the maximum propagation delay

  ```
  iverilog -o lab1.vpp lab1.v
  vvp lab1.vpp
  ```

- Simulate on specific input (generates `.vcd`, view with gtkwave for waveforms)

  ```
  iverilog -o simulate.vpp simulate.v
  vvp simulate.vpp
  ```

  