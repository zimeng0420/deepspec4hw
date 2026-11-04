# Web Research Results

Total Results: 1

## Result 1

The PS/2 keyboard uses a serial communication protocol to send data to the PS/2 controller. This protocol uses two wires: a clock line and a data line. The keyboard transmits data in a clocked serial format consisting of a start bit, 8 data bits (LSB first), an odd parity bit, and a stop bit. The clock signal is only active during data transmission. The data line is valid on the falling edge of the clock.

**Scan Codes**

The keyboard sends scan codes to the computer to indicate when a key is pressed or released. There are three sets of scan codes: Scan Code Set 1, Scan Code Set 2, and Scan Code Set 3. Scan Code Set 2 is the default set used by modern PS/2 keyboards.

*   **Make Codes:** When a key is pressed, a make code is transmitted. Most make codes are a single byte, but some extended keys use a two-byte sequence starting with 0xE0.
*   **Break Codes:** When a key is released, a break code is transmitted. For single-byte make codes, the break code is 0xF0 followed by the make code. For extended keys, the break code is 0xE0, 0xF0 followed by the key's code.

**Commands**

The PS/2 keyboard also accepts commands. Commands are one byte long. Some commands have data bytes that follow the command byte. The keyboard typically responds with an "ACK" (0xFA) to acknowledge a command or "Resend" (0xFE) if something was wrong.

**Example of Arrow Key Scancodes (Scan Code Set 2)**

*   Left Arrow: E0 6B (make), E0 F0 6B (break)
*   Down Arrow: E0 72 (make), E0 F0 72 (break)
*   Right Arrow: E0 74 (make), E0 F0 74 (break)
*   Up Arrow: E0 75 (make), E0 F0 75 (break)



---

