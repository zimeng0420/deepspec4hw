# Web Research Results

Total Results: 1

## Result 1

The PS/2 mouse protocol involves sending data in 3-byte packets, which include information about relative movement and button states. The first byte of each message has in=1, which serves as an indicator of the start of a new message. A PS/2 mouse communicates using a bidirectional synchronous serial protocol. The PS/2 interface includes clock and data inputs/outputs.

Here's a breakdown of the PS/2 mouse protocol and message structure:

**Message Structure:**

*   **Three-byte packets:** Data is transmitted in 3-byte packets, each containing information about mouse movement and button states.
*   **Byte 1 Indicator:** The first byte of each 3-byte message always has bit 3 set to 1 (in=1). This is the key to identifying the beginning of a new message within a continuous stream of bytes.
*   **Data Content:** Each packet consists of the relative movement since the last transmission and the button state. The data includes movement in the X and Y directions, typically in 9-bit two's complement notation, and the status of the mouse buttons.

**Synchronization:**

*   **Identifying Message Boundaries:** Because the PS/2 protocol sends a continuous stream of bytes, identifying message boundaries is crucial. The fact that the first byte of each three-byte message always has in=1 is the only indication of where a message starts and ends.
*   **Clock and Data Lines:** The PS/2 protocol uses two wires for communication: a clock line and a data line. The mouse generates the clock signal. Data is sent serially and is synchronized with the clock signal.
*   **Start Bit:** Data transmission begins with a start bit (logic 0), followed by 8 data bits (LSB first), a parity bit, and a stop bit (logic 1).
*   **Sampling Data:** Data sent from the device to the host is read on the falling edge of the clock signal.

**Additional details:**

*   The host has ultimate control over the bus and can inhibit communication by pulling the clock line low.
*   The clock frequency must be in the range of 10 - 16.7 kHz.
*   The mouse operates in different modes, including stream mode (default), remote mode and echo mode.
*   The PS/2 interface uses a 6-Pin Mini-DIN connector.


---

