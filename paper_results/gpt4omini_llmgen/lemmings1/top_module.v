module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    // State variable
    reg state, next_state;

    // Asynchronous reset
    always @* begin
        if (areset) begin
            next_state = WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                
                WALK_RIGHT: begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end

                default: next_state = WALK_LEFT;
            endcase
        end
    end

    // State update on clock edge
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    always @* begin
        walk_left = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
    end

endmodule