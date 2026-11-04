module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            // Determine neighbors, handling boundaries
            integer left, right;
            if (i == 0) begin
                left = 0;
            end else begin
                left = q[i - 1];
            end

            if (i == 511) begin
                right = 0;
            end else begin
                right = q[i + 1];
            end

            // Rule 110 logic
            case ({left, q[i], right})
                3'b111: next_q[i] = 0;
                3'b110: next_q[i] = 1;
                3'b101: next_q[i] = 1;
                3'b100: next_q[i] = 0;
                3'b011: next_q[i] = 1;
                3'b010: next_q[i] = 1;
                3'b001: next_q[i] = 1;
                3'b000: next_q[i] = 0;
                default: next_q[i] = 0; //Should not happen, but good practice.
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule