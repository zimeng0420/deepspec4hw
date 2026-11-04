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
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Output register (Moore machine)
    reg out;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
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
            default: next_state = A;  // Should not happen, but good practice
        endcase
    end

    // Output logic
    always @(current_state) begin
        case (current_state)
            D: out = 1;
            default: out = 0;
        endcase
    end

endmodule