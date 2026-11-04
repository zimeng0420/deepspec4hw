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
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;
    
    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right)
                    next_state = WALK_LEFT; // Stay left, ignore bump_right.
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else if (!ground)
                    next_state = FALLING;
                else
                    next_state = WALK_LEFT;

            end
            WALK_RIGHT: begin
                if (bump_left)
                    next_state = WALK_RIGHT; // Stay right, ignore bump_left.
                else if (bump_right)
                    next_state = WALK_LEFT;
                else if (!ground)
                    next_state = FALLING;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground)
                    if (current_state == FALLING) begin  //Avoid a glitch that might occur in the same clock cycle
                        if(walk_left) next_state = WALK_LEFT;
                        else next_state = WALK_RIGHT;
                    end
                    else
                       next_state = FALLING; //Keep in FALLING state if ground == 1 but not in the falling state.
                else
                    next_state = FALLING; // Stay falling if ground still not active.

            end
            default:
                next_state = WALK_LEFT;
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end
    
    // Output logic (Moore machine)
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
            WALK_RIGHT: begin
                walk_left  = 0;
                walk_right = 1;
                aaah       = 0;
            end
            FALLING: begin
                walk_left  = 0;
                walk_right = 0;
                aaah       = 1;
            end
            default: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
        endcase
    end

endmodule