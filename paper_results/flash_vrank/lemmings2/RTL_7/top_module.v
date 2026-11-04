module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Define state encoding
    localparam WALK_LEFT_STATE  = 2'b00;
    localparam WALK_RIGHT_STATE = 2'b01;
    localparam FALLING_LEFT_STATE = 2'b10;
    localparam FALLING_RIGHT_STATE = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Output registers
    reg r_walk_left;
    reg r_walk_right;
    reg r_aaah;

    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT_STATE: begin
                if (!ground) begin
                    next_state = FALLING_LEFT_STATE;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT_STATE;
                end else begin
                    next_state = WALK_LEFT_STATE;
                end
            end
            WALK_RIGHT_STATE: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT_STATE;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT_STATE;
                end else begin
                    next_state = WALK_RIGHT_STATE;
                end
            end
            FALLING_LEFT_STATE: begin
                if (ground) begin
                    next_state = WALK_LEFT_STATE;
                end else begin
                    next_state = FALLING_LEFT_STATE;
                end
            end
            FALLING_RIGHT_STATE: begin
                if (ground) begin
                    next_state = WALK_RIGHT_STATE;
                end else begin
                    next_state = FALLING_RIGHT_STATE;
                end
            end
            default: next_state = WALK_LEFT_STATE;
        endcase
    end

    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT_STATE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        r_walk_left  = 0;
        r_walk_right = 0;
        r_aaah       = 0;

        case (current_state)
            WALK_LEFT_STATE: begin
                r_walk_left  = 1;
                r_walk_right = 0;
                r_aaah       = 0;
            end
            WALK_RIGHT_STATE: begin
                r_walk_left  = 0;
                r_walk_right = 1;
                r_aaah       = 0;
            end
            FALLING_LEFT_STATE: begin
                r_walk_left  = 0;
                r_walk_right = 0;
                r_aaah       = 1;
            end
            FALLING_RIGHT_STATE: begin
                r_walk_left  = 0;
                r_walk_right = 0;
                r_aaah       = 1;
            end
            default: begin
                r_walk_left = 1;
                r_walk_right = 0;
                r_aaah = 0;
            end
        endcase
    end

    // Assign outputs
    assign walk_left  = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah       = r_aaah;

endmodule