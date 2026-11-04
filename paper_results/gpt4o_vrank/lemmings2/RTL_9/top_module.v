module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State definition
    typedef enum reg [1:0] {
        LEFT = 2'b00,
        RIGHT = 2'b01,
        FALL_LEFT = 2'b10,
        FALL_RIGHT = 2'b11
    } state_t;
    
    state_t state, next_state;

    // State transition and output logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) begin // Begins to fall
                    next_state = FALL_LEFT; 
                end else if (bump_left) begin 
                    next_state = RIGHT; 
                end else begin
                    next_state = LEFT;
                end
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
            RIGHT: begin
                if (!ground) begin // Begins to fall
                    next_state = FALL_RIGHT; 
                end else if (bump_right) begin 
                    next_state = LEFT; 
                end else begin
                    next_state = RIGHT;
                end
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end
            FALL_LEFT: begin
                if (ground) begin // Ground reappears
                    next_state = LEFT; 
                end else begin
                    next_state = FALL_LEFT;
                end
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end
            FALL_RIGHT: begin
                if (ground) begin // Ground reappears
                    next_state = RIGHT; 
                end else begin
                    next_state = FALL_RIGHT;
                end
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end
            default: begin
                next_state = LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end

    // State update on clock edge or asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end

endmodule