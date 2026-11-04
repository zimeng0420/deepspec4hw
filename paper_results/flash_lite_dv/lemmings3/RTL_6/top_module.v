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

    // State Definitions
    parameter WALKING_LEFT = 2'b00;
    parameter WALKING_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // State Register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Default values
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational Logic for Next State and Outputs
    always @(*) begin
        // Default output values
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = current_state;

        case (current_state)
            WALKING_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end

            WALKING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALKING_LEFT;
                end else begin
                    walk_right = 1;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if(walk_left)
                       next_state = WALKING_LEFT;
                    else
                        next_state = WALKING_RIGHT;
                end
            end

            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                end else if(walk_left) begin
                     walk_left = 1;
                 end
                 else begin
                    walk_right = 1;
                end
            end

            default: begin
                next_state = WALKING_LEFT;
                walk_left = 1;
            end
        endcase
    end

endmodule