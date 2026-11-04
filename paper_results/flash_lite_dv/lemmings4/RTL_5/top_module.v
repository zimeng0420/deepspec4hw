module top_module(
    input clk,
    input areset,
    input ground,
    input bump_left,
    input bump_right,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg falling,
    output reg digging
);

    // Define states
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // Declare state register and next state logic
    reg [1:0] state, next_state;

    // Falling counter
    reg [5:0] fall_counter;

    // Default output assignments
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        falling = 0;
        digging = 0;
    end

    // State transition logic
    always @(*) begin
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig & ground) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig & ground) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = FALLING; //splatter, stay in falling
                    end else begin
                        if (walk_left)
                           next_state = WALK_LEFT;
                        else
                           next_state = WALK_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'b0;
        end else begin
            state <= next_state;
        end
    end

    // Output assignments based on state
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                falling = 0;
                digging = 0;
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                falling = 0;
                digging = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                falling = 1;
                digging = 0;
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                falling = 0;
                digging = 1;
            end
        endcase
    end
    
    // Falling counter update
    always @(posedge clk) begin
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'b0;
        end
    end

    // Splatter logic (outputs go to zero)
    always @(*) begin
        if (state == FALLING && ground && fall_counter > 20) begin
            walk_left = 0;
            walk_right = 0;
            falling = 0;
            digging = 0;
        end
    end

endmodule