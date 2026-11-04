module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State definition
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;

    // State register (holds the current state)
    reg [1:0] state;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
          case (state)
            WALK_LEFT:  begin
                            if (bump_right)
                                state <= WALK_RIGHT;
                            else
                                state <= WALK_LEFT;
                         end
            WALK_RIGHT: begin
                            if (bump_left)
                                state <= WALK_LEFT;
                            else
                                state <= WALK_RIGHT;
                         end
            default:    state <= WALK_LEFT; // Default to WALK_LEFT (should not happen)
          endcase
    end

    // Output logic (Moore machine - outputs depend only on the state)
    always @(*) begin
        case (state)
            WALK_LEFT:  begin
                            walk_left = 1;
                            walk_right = 0;
                        end
            WALK_RIGHT: begin
                            walk_left = 0;
                            walk_right = 1;
                        end
            default:    begin
                            walk_left = 1;
                            walk_right = 0; // Default to WALK_LEFT (should not happen)
                        end
        endcase
    end

endmodule