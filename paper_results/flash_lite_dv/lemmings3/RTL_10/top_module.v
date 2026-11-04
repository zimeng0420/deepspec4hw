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
    parameter IDLE = 2'b00;        // Initial state, walking in a direction
    parameter FALLING = 2'b01;     // Falling state
    parameter DIGGING = 2'b10;     // Digging state

    // State register
    reg [1:0] state;
    reg [1:0] next_state;

    // Internal signals
    reg falling_next;
    reg digging_next;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default output values
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        falling_next = 0;
        digging_next = 0;

        case (state)
            IDLE: begin
                if (!ground) begin
                    next_state = FALLING;
                    falling_next = 1;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging_next = 1;
                end else begin
                    next_state = IDLE;
                    if (bump_left) begin
                        walk_right = 1;
                    end else if (bump_right) begin
                        walk_left = 1;
                    end else if (walk_left) begin
                        walk_left = 1;
                    end else if(walk_right) begin
                        walk_right = 1;
                    end
                end
            end
            FALLING: begin
                next_state = ground ? IDLE : FALLING;
                aaah = 1;
                if (!ground)
                    falling_next = 1;
                
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    falling_next = 1;
                end else {
                   next_state = DIGGING;
                   digging_next = 1;
                 }
            end
            default: begin
                next_state = IDLE;
            end
        endcase
        
    end

    //Output Assignment
    always @(*) begin
        if(state == FALLING) begin
            aaah = 1;
            digging = 0;
        end else if (state == DIGGING) {
            digging = 1;
            aaah = 0;
        }
         else begin
            aaah = 0;
            digging = 0;
        end
        
        if(state == IDLE){
           if (walk_left && !bump_right)
               walk_left = 1;
           else if (walk_right && !bump_left)
               walk_right = 1;
           else if (bump_left)
                walk_right = 1;
           else if (bump_right)
                walk_left = 1;
           else if(walk_left)
                walk_left = 1;
           else if(walk_right)
               walk_right = 1;
            else
               walk_left = 1;
        }
        
    end
end