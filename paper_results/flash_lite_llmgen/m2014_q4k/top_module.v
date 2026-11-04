module top_module (
    input clk,
    input resetn,
    input in,
    output out
);

    // Internal signals (wires)
    reg [3:0] shift_reg; // 4-bit register to hold the shifted data

    // Sequential logic (always block)
    always @(posedge clk) begin
        if (!resetn) begin // Synchronous active-low reset
            shift_reg <= 4'b0000; // Reset all flip-flops to 0
        end else begin
            shift_reg[3] <= shift_reg[2]; // Shift data right
            shift_reg[2] <= shift_reg[1];
            shift_reg[1] <= shift_reg[0];
            shift_reg[0] <= in; // Load input data into the first flip-flop
        end
    end

    // Output assignment
    assign out = shift_reg[3]; // Output the value of the last flip-flop

endmodule