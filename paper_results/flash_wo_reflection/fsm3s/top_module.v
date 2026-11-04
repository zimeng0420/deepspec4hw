module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // Define the states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Output register (Moore machine)
    reg out_r;
    assign out = out_r;

    // State transition logic (sequential)
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational)
    always_comb begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end
            C: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output logic (combinational)
    always_comb begin
        case (current_state)
            A: out_r = 0;
            B: out_r = 0;
            C: out_r = 0;
            D: out_r = 1;
            default: out_r = 0; // Should not happen, but good practice
        endcase
    end

endmodule