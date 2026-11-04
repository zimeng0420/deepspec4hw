module top_module(
    input clk,
    input d,
    output reg q
);

    // Internal signals
    reg q_posedge; // Output of the flip-flop triggered on the rising edge
    reg q_negedge; // Output of the flip-flop triggered on the falling edge

    // Rising-edge triggered flip-flop
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Falling-edge triggered flip-flop
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Combinational logic to combine the outputs
    always @(*) begin
        // The output 'q' is updated based on the most recent edge.
        // This ensures that the output reflects the latest data.
        if (clk) begin // If clk is high, use the rising edge data
            q = q_posedge;
        end else begin // If clk is low, use the falling edge data
            q = q_negedge;
        end
    end

endmodule