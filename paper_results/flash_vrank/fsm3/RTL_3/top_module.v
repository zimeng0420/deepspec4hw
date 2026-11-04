module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // Define the states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State register
    reg state;

    // Next state logic
    reg next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        } else begin
            state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
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

    // Output logic
    assign out = (state == D) ? 1 : 0;

endmodule