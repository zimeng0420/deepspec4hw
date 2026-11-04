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

    // Define states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG = 2'b10;

    reg [1:0] current_state, next_state;
    reg walking_left; // Remember direction before falling/digging

    // State transition logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    walking_left = 0;
                end else if (bump_right) begin
                    walking_left = 1;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end
            default: next_state = WALK;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_left <= 1;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (current_state == WALK) && walking_left;
    assign walk_right = (current_state == WALK) && !walking_left;
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

endmodule