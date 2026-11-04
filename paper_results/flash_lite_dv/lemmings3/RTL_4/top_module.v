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
    parameter IDLE = 2'b00;
    parameter WALKING_LEFT = 2'b01;
    parameter WALKING_RIGHT = 2'b10;
    parameter FALLING = 2'b11;

    // State register
    reg [1:0] state;

    // Internal signals
    reg digging_internal; // Internal signal for digging

    // Asynchronous reset
    always @(posedge areset) begin
        state <= WALKING_LEFT; // Reset to walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        digging_internal <= 1'b0; // Reset internal digging signal
    end

    // State transition and output logic
    always @(posedge clk) begin
        // Default values
        walk_left <= walk_left;
        walk_right <= walk_right;
        aaah <= 1'b0;
        digging <= digging_internal; // Synchronize digging_internal to digging
        digging_internal <= digging_internal; // Default, keep digging state

        case (state)
            IDLE: begin // Should not happen, to be safe
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                if (!ground) begin
                    state <= FALLING;
                    aaah <= 1'b1;
                end else if (dig && ground) begin
                    digging_internal <= 1'b1;
                end
            end
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    aaah <= 1'b1;
                end else if (dig && ground) begin
                    digging_internal <= 1'b1;
                end else if (bump_right) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    state <= WALKING_RIGHT;
                end

            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    aaah <= 1'b1;
                end else if (dig && ground) begin
                    digging_internal <= 1'b1;
                end else if (bump_left) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    state <= WALKING_LEFT;
                end
            end
            FALLING: begin
                aaah <= 1'b1;
                digging_internal <= 1'b0;
                if (ground) begin
                    if (walk_left) begin
                        state <= WALKING_LEFT;
                    end else begin
                        state <= WALKING_RIGHT;
                    end

                end

            end
        endcase
        // Digging logic, inside the main always block to be in sync with the main state.
        if(digging_internal && !ground) begin
            digging_internal <= 1'b0;
        end
        digging <= digging_internal;
    end

endmodule