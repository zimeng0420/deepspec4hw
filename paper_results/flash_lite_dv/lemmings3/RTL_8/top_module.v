module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Define states
    parameter IDLE = 2'b00;  // Initial state, walking left
    parameter WALKING_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;
    
    reg [1:0] state;

    // Asynchronous reset
    always @(posedge areset) begin
        state <= IDLE;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end

    // State transition and output logic
    always @(posedge clk) begin
        // Default outputs
        aaah <= 0;
        digging <= 0;

        case (state)
            IDLE: begin
                walk_left <= 1;
                walk_right <= 0;
                if (~ground) begin
                    state <= FALLING;
                    aaah <= 1;
                end else if (dig && ground) begin
                    state <= DIGGING;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= WALKING_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                end
            end
            
            WALKING_RIGHT: begin
                walk_left <= 0;
                walk_right <= 1;

                if (~ground) begin
                    state <= FALLING;
                    aaah <= 1;
                end else if (dig && ground) begin
                    state <= DIGGING;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= IDLE;
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end

            FALLING: begin
                walk_left <= walk_left;  // Maintain direction
                walk_right <= walk_right;
                aaah <= 1;
                digging <= 0;
                if (ground) begin
                    if (walk_left) begin
                        state <= IDLE;
                    end else begin
                        state <= WALKING_RIGHT;
                    end
                end
            end

            DIGGING: begin
                walk_left <= walk_left;  // Maintain direction
                walk_right <= walk_right;
                digging <= 1;
                if (~ground) begin
                    state <= FALLING;
                    aaah <= 1;
                    digging <= 0;
                end
            end

            default: begin
                state <= IDLE;
                walk_left <= 1;
                walk_right <= 0;
            end
        endcase
    end

endmodule