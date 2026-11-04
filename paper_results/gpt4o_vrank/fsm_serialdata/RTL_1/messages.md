# Messages for Task: fsm_serialdata

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.In many (older) serial communications protocols, each data byte is sent along with a start bit and a stop bit, to help the receiver delimit bytes from the stream of bits. One common scheme is to use one start bit (0), 8 data bits, and 1 stop bit (1). The line is also at logic 1 when nothing is being transmitted (idle). Design a finite state machine that will identify when bytes have been correctly received when given a stream of bits. It needs to identify the start bit, wait for all 8 data bits, then verify that the stop bit was correct. The module will also output the correctly-received data byte. out_byte needs to be valid when done is 1, and is don't-care otherwise.If the stop bit does not appear when expected, the FSM must wait until it finds a stop bit before attempting to receive the next byte. Include a active-high synchronous reset. Note that the serial protocol sends the least significant bit first. It should assert done each time it finds a stop bit.
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

