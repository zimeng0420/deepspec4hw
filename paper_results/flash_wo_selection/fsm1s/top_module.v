module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    reg current_state;
    parameter A = 0, B = 1;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            case (current_state)
                A: begin
                    if (in == 0) begin
                        current_state <= B;
                    end else begin
                        current_state <= A;
                    end
                end
                B: begin
                    if (in == 0) begin
                        current_state <= A;
                    end else begin
                        current_state <= B;
                    end
                end
                default: current_state <= B; // Should not happen, but good practice
            endcase
        end
    end

    assign out = current_state;

endmodule