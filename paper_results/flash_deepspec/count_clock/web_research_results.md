# Web Research Results

Total Results: 1

## Result 1

Here's a Verilog implementation of a 12-hour clock with an enable signal and synchronous reset, based on the information gathered.

```verilog
module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

  reg [3:0] ss_ones;   // Seconds ones digit (0-9)
  reg [3:0] ss_tens;   // Seconds tens digit (0-5)
  reg [3:0] mm_ones;   // Minutes ones digit (0-9)
  reg [3:0] mm_tens;   // Minutes tens digit (0-5)
  reg [3:0] hh_ones;   // Hours ones digit (1-9, 0, 1, 2)
  reg [3:0] hh_tens;   // Hours tens digit (0-1)

  // Seconds counter
  always @(posedge clk) begin
    if (reset) begin
      ss_ones <= 4'd0;
      ss_tens <= 4'd0;
    end else if (ena) begin
      if (ss_ones == 4'd9) begin
        ss_ones <= 4'd0;
        if (ss_tens == 4'd5) begin
          ss_tens <= 4'd0;
          // Increment minutes
          if (mm_ones == 4'd9) begin
            mm_ones <= 4'd0;
            if (mm_tens == 4'd5) begin
              mm_tens <= 4'd0;
              // Increment hours
              if ((hh_ones == 4'd2) && (hh_tens == 4'd1)) begin
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
                pm <= ~pm;  // Toggle AM/PM
              end else if (hh_ones == 4'd9 && hh_tens == 4'd0) begin
                  hh_ones <= 4'd0;
                  hh_tens <= 4'd1;
              end else if (hh_ones == 4'd0 && hh_tens == 4'd1) begin
                  hh_ones <= 4'd1;
                  hh_tens <= 4'd1;
              end else if (hh_ones == 4'd1 && hh_tens == 4'd1) begin
                  hh_ones <= 4'd2;
                  hh_tens <= 4'd1;
              end else begin
                hh_ones <= hh_ones + 4'd1;
              end
            end else begin
              mm_tens <= mm_tens + 4'd1;
            end
          end else begin
            mm_ones <= mm_ones + 4'd1;
          end
        end else begin
          ss_tens <= ss_tens + 4'd1;
        end
      end else begin
        ss_ones <= ss_ones + 4'd1;
      end
    end
  end

  // Output assignments (BCD to 7-segment conversion would be needed for display)
  always @(*) begin
    hh = {hh_tens, hh_ones};
    mm = {mm_tens, mm_ones};
    ss = {ss_tens, ss_ones};
  end

  // Reset logic (synchronous)
  always @(posedge clk) begin
    if (reset) begin
      ss_ones <= 4'd0;
      ss_tens <= 4'd0;
      mm_ones <= 4'd0;
      mm_tens <= 4'd0;
      hh_ones <= 4'd2;
      hh_tens <= 4'd1;
      pm <= 1'b0;  // AM
    end
  end

endmodule
```

Key points of this implementation:

*   **Module Definition:** The code defines a module `top_module` with the specified inputs (`clk`, `reset`, `ena`) and outputs (`pm`, `hh`, `mm`, `ss`).
*   **Internal Registers:** Internal registers are used to store the BCD values for seconds, minutes, and hours. This is crucial for sequential logic in Verilog.
*   **Enable Signal:** The counter increments only when the `ena` input is asserted.
*   **BCD Counters:** The code implements BCD (Binary Coded Decimal) counters for seconds, minutes and hours. The seconds and minutes count from 0 to 59, while the hours count from 1 to 12.
*   **12-Hour Clock Logic:** The hour counter increments correctly from 1 to 12 and then rolls over to 1. The `pm` signal toggles when the hour rolls over from 12 to 1.
*   **Synchronous Reset:** The clock resets to 12:00 AM when the `reset` input is asserted. The reset is synchronous, meaning it takes effect on the rising edge of the clock. Reset has higher priority than enable because it is checked first in the `always` block.
*   **Output Assignment:** The final values of hours, minutes, and seconds are assigned to the output ports. Note that these are BCD values; you would typically need additional logic to convert these to a 7-segment display format for viewing.

Important considerations:

*   **Clock Frequency:** This code assumes a fast clock (`clk`) and relies on the `ena` signal to provide the 1 Hz (one pulse per second) increment signal.  You'll need a separate clock divider circuit to generate the `ena` signal from the fast clock.
*   **BCD to 7-Segment Conversion:**  To display the time on 7-segment displays, you'll need to add a BCD-to-7-segment decoder for each digit.
*   **Testbench:**  Thoroughly test this code with a Verilog testbench to verify its functionality.
*   **Synthesis:**  This code is written in a behavioral style and should be synthesizable by most Verilog compilers.


---

