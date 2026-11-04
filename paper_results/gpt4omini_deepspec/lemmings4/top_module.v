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

    // States
    typedef enum reg [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11,
        SPLATTERED = 2'b100
    } state_t;

    // State variable
    state_t current_state, next_state;
    
    // Counter for falling cycles
    reg [4:0] fall_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = current_state;

        case (current_state)
            WALK_LEFT: begin
                if (~ground) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (dig) begin
                    if (ground) begin
                        digging = 1;
                        next_state = DIGGING;
                    end
                end else if (bump_right) begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (dig) begin
                    if (ground) begin
                        digging = 1;
                        next_state = DIGGING;
                    end
                end else if (bump_left) begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1;
                end
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                    end
                end
            end
            
            DIGGING: begin
                digging = 1;
                if (~ground) begin
                    next_state = FALLING;
                end else if (ground) begin
                    // Continue digging
                    next_state = DIGGING;
                end
            end
            
            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end
endmodule