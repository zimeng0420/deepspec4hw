module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [2:0] {
        IDLE,
        RECEIVE,
        INVERT,
        ADD_ONE,
        OUTPUT
    } state_t;

    state_t current_state, next_state;
    logic [7:0] received_bits; // Assume max input length of 8 bits for demonstration
    logic [7:0] inverted_bits;
    logic [7:0] result;         // To hold 2's complement result
    logic carry;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            received_bits <= 8'b0;
            z <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (!areset) 
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                // Assume we can input bits until a predefined number or termination condition
                next_state = INVERT; // For demonstration, go directly to INVERT after first bit
            end
            INVERT: begin
                next_state = ADD_ONE;
            end
            ADD_ONE: begin
                next_state = OUTPUT;
            end
            OUTPUT: begin
                next_state = IDLE; // Returns to IDLE after output
            end
            default: next_state = IDLE;
        endcase
    end

    // Output generation and internal logic
    always_ff @(posedge clk) begin
        case (current_state)
            RECEIVE: begin
                received_bits <= {received_bits[6:0], x}; // Shift in the new bit
            end
            INVERT: begin
                inverted_bits <= ~received_bits; // Inversion of the received bits
            end
            ADD_ONE: begin
                {carry, result} = inverted_bits + 1; // Add 1 to inverted bits
            end
            OUTPUT: begin
                z <= result[0]; // Output LSB of result
            end
        endcase
    end

endmodule