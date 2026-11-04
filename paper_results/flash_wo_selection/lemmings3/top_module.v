module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State definition
    localparam WALK_LEFT_STATE = 2'b00;
    localparam WALK_RIGHT_STATE = 2'b01;
    localparam FALLING_STATE = 2'b10;
    localparam DIGGING_STATE = 2'b11;

    // State register
    reg [1:0] current_state;

    // Output registers
    reg r_walk_left;
    reg r_walk_right;
    reg r_aaah;
    reg r_digging;

    // Assign outputs
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT_STATE;
        end else begin
            case (current_state)
                WALK_LEFT_STATE: begin
                    if (!ground) begin
                        current_state <= FALLING_STATE;
                    end else if (dig) begin
                        current_state <= DIGGING_STATE;
                    end else if (bump_left || bump_right) begin
                        current_state <= WALK_RIGHT_STATE;
                    end else begin
                        current_state <= WALK_LEFT_STATE;
                    end
                end
                WALK_RIGHT_STATE: begin
                    if (!ground) begin
                        current_state <= FALLING_STATE;
                    end else if (dig) begin
                        current_state <= DIGGING_STATE;
                    end else if (bump_left || bump_right) begin
                        current_state <= WALK_LEFT_STATE;
                    end else begin
                        current_state <= WALK_RIGHT_STATE;
                    end
                end
                FALLING_STATE: begin
                    if (ground) begin
                        // Retain previous walking direction
                        if (r_walk_left) begin
                            current_state <= WALK_LEFT_STATE;
                        end else begin
                            current_state <= WALK_RIGHT_STATE;
                        end
                    end else begin
                        current_state <= FALLING_STATE;
                    end
                end
                DIGGING_STATE: begin
                    if (!ground) begin
                        current_state <= FALLING_STATE;
                    end else begin
                        current_state <= DIGGING_STATE;
                    end
                end
                default: current_state <= WALK_LEFT_STATE; // Should not happen, but good to have
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (current_state)
            WALK_LEFT_STATE: begin
                r_walk_left = 1;
                r_walk_right = 0;
                r_aaah = 0;
                r_digging = 0;
            end
            WALK_RIGHT_STATE: begin
                r_walk_left = 0;
                r_walk_right = 1;
                r_aaah = 0;
                r_digging = 0;
            end
            FALLING_STATE: begin
                r_walk_left = 0;
                r_walk_right = 0;
                r_aaah = 1;
                r_digging = 0;
            end
            DIGGING_STATE: begin
                r_walk_left = 0;
                r_walk_right = 0;
                r_aaah = 0;
                r_digging = 1;
            end
            default: begin
                r_walk_left = 1;
                r_walk_right = 0;
                r_aaah = 0;
                r_digging = 0;
            end
        endcase
    end

endmodule