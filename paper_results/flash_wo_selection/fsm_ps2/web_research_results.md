# Web Research Results

Total Results: 1

## Result 1

The PS/2 mouse protocol sends messages that are three bytes long. Within a continuous byte stream, message boundaries are not obvious. The first byte of each three-byte message always has bit=1, but bit of the other two bytes may be 1 or 0 depending on the data. An FSM can search for message boundaries by discarding bytes until a byte with in=1 is detected. This byte is assumed to be byte 1 of a message, and a signal is sent once all 3 bytes have been received. The FSM should signal "done" in the cycle immediately after the third byte of each message is successfully received.

Here's how the PS/2 mouse protocol works:

*   **Data Transmission:** The mouse sends data in 3-byte packets, representing relative movement and button states.
*   **Start Bit Identification:** The first byte of each packet has bit 3 set to 1, which helps in identifying the start of a new message.
*   **Finite State Machine Implementation:** A finite state machine can be used to identify the message boundaries and extract the data. The FSM discards data until it finds a byte where bit 3 is 1, marking the potential start of a 3-byte sequence. After receiving three bytes, the FSM asserts a 'done' signal.
*   **States:** Approximately four states are needed. Three states might not be enough because one state needs to assert "done", and "done" is asserted for only one cycle for each received message.
*   **Module Declaration:** Although in[7:0] is a byte, the FSM only has one input: in.

Module Definition:

```verilog
module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);
```

The module `top_module` has a clock input `clk`, an 8-bit data input `in`, a reset input `reset`, and a `done` output.


---

