### Technical Specification for Heating/Cooling Thermostat Circuit

#### Inputs:
1. **mode (1-bit input):**
   - Indicates the mode of the thermostat.
   - `1` = Heating Mode
   - `0` = Cooling Mode

2. **too_cold (1-bit input):**
   - Indicates if the current temperature is too cold.
   - Active High: `1` = Too cold

3. **too_hot (1-bit input):**
   - Indicates if the current temperature is too hot.
   - Active High: `1` = Too hot

4. **fan_on (1-bit input):**
   - Indicates user request for fan operation regardless of heater or AC status.
   - Active High: `1` = Fan requested to be on

#### Outputs:
1. **heater (1-bit output):**
   - Controls the heater device.
   - Active High: `1` = Heater on

2. **aircon (1-bit output):**
   - Controls the air conditioning unit.
   - Active High: `1` = Air conditioner on

3. **fan (1-bit output):**
   - Controls the blower fan.
   - Active High: `1` = Fan on

#### Functionality:
- **Heating Mode (mode = 1):**
  - **Heater Operation:**
    - `heater = 1` if `too_cold = 1`.
    - `heater = 0` if `too_cold = 0`.
  - **Air Conditioner Operation:**
    - `aircon = 0` (Air conditioner never operates in heating mode).
  - **Fan Operation:**
    - `fan = 1` if `heater = 1 OR fan_on = 1`.
    - `fan = 0` otherwise.

- **Cooling Mode (mode = 0):**
  - **Air Conditioner Operation:**
    - `aircon = 1` if `too_hot = 1`.
    - `aircon = 0` if `too_hot = 0`.
  - **Heater Operation:**
    - `heater = 0` (Heater never operates in cooling mode).
  - **Fan Operation:**
    - `fan = 1` if `aircon = 1 OR fan_on = 1`.
    - `fan = 0` otherwise.

#### Notes:
- The `fan` output should activate when either the heating or cooling mechanism is active, or if manually requested via `fan_on`.
- Only one primary mechanism (either heater or air conditioner) operates based on the current mode (heating or cooling).
- Prioritize safety by ensuring that the air conditioner and heater are never operational at the same time.