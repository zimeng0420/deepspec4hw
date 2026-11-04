module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);
    
    // State definitions
    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: begin
                if (a) begin
                    p <= 0;
                    q <= 0;
                    state <= 2'b01;
                end
            end
            2'b01: begin
                p <= 0;
                q <= 0;
                if (a) state <= 2'b10; // Move to state 2 if a is 1
            end
            2'b10: begin
                p <= 1; // Set p
                q <= 0; // Set q to 0
                if (!a) state <= 2'b11; // Go to state 3
            end
            2'b11: begin
                p <= 1; // p remains 1
                q <= 1; // Set q to 1
                if (!a) state <= 2'b00; // Go back to state 0
            end
        endcase
    end

    initial begin
        state = 2'b00; // Initial state
        p = 0; // Initialize p
        q = 0; // Initialize q
    end

endmodule