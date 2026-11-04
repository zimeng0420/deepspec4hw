# Web Research Results

Total Results: 1

## Result 1

A Galois LFSR is a type of linear feedback shift register (LFSR) where the bit positions with a "tap" are XORed with the output bit to determine the next value, while the other bit positions shift. If the tap positions are carefully selected, the LFSR can be designed to be "maximum-length". A maximum-length LFSR with *n* bits cycles through 2^*n*-1 states before repeating; the all-zeros state is not reached.

**Galois LFSR Configuration**
In a Galois configuration, bits that are not taps are shifted one position to the right unchanged when the system is clocked. The taps, however, are XORed with the output bit before being stored in the next position. The new output bit becomes the next input bit.

**Taps**
The bit positions that act as an input to a linear function to affect the next state are known as taps. The arrangement of taps for feedback in an LFSR can be expressed in finite field arithmetic as a polynomial mod 2. The powers of the terms represent the tapped bits, counting from the left. The first and last bits are always connected as an input and output tap, respectively.

**Maximum Length LFSR**
An LFSR is maximal-length if and only if the corresponding feedback polynomial is primitive over the Galois field GF(2). For an *n*-bit LFSR, if the tap sequence is [n, A, B, C, 0], then the corresponding mirror sequence is [n, n − C, n − B, n − A, 0]. Both give a maximum-length sequence.

**Synchronous Reset**
In a synchronous reset, the reset signal is synchronized with the clock signal. The reset will occur with respect to the clock edge. The design captures the reset assertion only when there is a positive edge of a clock.


---

