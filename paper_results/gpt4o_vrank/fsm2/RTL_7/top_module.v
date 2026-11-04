module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [0:0] {
        OFF = 1'b0, // State where out = 0
        ON  = 1'b1  // State where out = 1
    } state_t;

    // State registers
    reg state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
        endcase
    end

    // State update (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF; // Asynchronous reset to OFF state
        else
            state <= next_state;
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
        endcase
    end

endmodule