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

    // State definition
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;


    reg [1:0] current_state, next_state;

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) {
                    next_state = WALK_RIGHT;
                }
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                   if (current_state == FALLING) begin
                        if (previous_direction) begin
                            next_state = WALK_RIGHT;
                        end else begin
                            next_state = WALK_LEFT;
                        end
                    end
                end
            end
            default: next_state = WALK_LEFT; // Should not happen, but reset to a safe state
        endcase
    end
    
    reg previous_direction;
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            previous_direction <= 0;
        end else if (current_state == WALK_LEFT && next_state == FALLING) begin
             previous_direction <= 0;
        end else if (current_state == WALK_RIGHT && next_state == FALLING) begin
             previous_direction <= 1;
        end 
    end


    // Output logic (Moore machine)
    assign walk_left  = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah       = (current_state == FALLING);

endmodule