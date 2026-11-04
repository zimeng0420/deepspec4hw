module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [3:0] state, next_state;
    
    // Define states
    localparam S0 = 4'b0000;  // Initial state
    localparam S1 = 4'b0001;  // 0 detected
    localparam S2 = 4'b0010;  // 01 detected
    localparam S3 = 4'b0011;  // 011 detected
    localparam S4 = 4'b0100;  // 0111 detected
    localparam S5 = 4'b0101;  // 01111 detected
    localparam S6 = 4'b0110;  // 011111 detected
    localparam DISCARD = 4'b0111;  // 0111110 detected (discard)
    localparam FLAG = 4'b1000;  // 01111110 detected (flag)
    localparam ERROR = 4'b1001;  // 01111111 detected (error)
    localparam S7 = 4'b1010;  // 0111111 detected

    // State transition logic
    always @(*) begin
        next_state = state;  // Default stay in current state
        disc = 0;
        flag = 0;
        err = 0;
        
        case (state)
            S0: if (in == 0) next_state = S1;
            S1: if (in == 1) next_state = S2; else next_state = S1;
            S2: if (in == 1) next_state = S3; else next_state = S1;
            S3: if (in == 1) next_state = S4; else next_state = S1;
            S4: if (in == 1) next_state = S5; else next_state = S1;
            S5: if (in == 1) next_state = S6; else next_state = S1;
            S6: if (in == 0) next_state = DISCARD;
                else if (in == 1) next_state = S7;
            DISCARD: begin
                next_state = S1;
                disc = 1;
            end
            S7: if (in == 0) begin
                next_state = FLAG;
            end
            else if (in == 1) begin
                next_state = ERROR;
            end
            FLAG: begin
                next_state = S1;
                flag = 1;
            end
            ERROR: begin
                next_state = S0;
                err = 1;
            end
            default: next_state = S0;
        endcase
    end

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

endmodule