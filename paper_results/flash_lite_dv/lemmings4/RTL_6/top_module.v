module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg fall,
    output reg digging,
    output reg [7:0] aaah
);

    // State Definitions
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    reg [1:0] state;
    reg [5:0] fall_counter;

    // Default output values
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        fall = 0;
        digging = 0;
        aaah = 8'b0;
    end

    // State Transition Logic and Output Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'b0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    walk_left = 1;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                        fall = 1;
                        aaah <= "aaah!";
                    end else if (bump_right) begin
                        state <= WALK_LEFT; // redundant, but explicitly clarifies
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        digging = 1;
                    end else if (bump_left) begin
                         state <= WALK_RIGHT;
                    end
                end
                WALK_RIGHT: begin
                    walk_right = 1;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                        fall = 1;
                        aaah <= "aaah!";
                    end else if (bump_left) begin
                        state <= WALK_RIGHT; // redundant, but explicitly clarifies
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        digging = 1;
                    end else if (bump_right) begin
                         state <= WALK_LEFT;
                    end
                end
                FALLING: begin
                    fall = 1;
                    aaah <= "aaah!";
                    fall_counter <= fall_counter + 1;
                    if (ground) begin
                        if (fall_counter > 20) begin
                           state <= FALLING; //splatter, but stay here
                           walk_left <= 0;
                           walk_right <= 0;
                           fall <= 0;
                           digging <= 0;
                        end
                        else begin
                            if (walk_left)
                                state <= WALK_LEFT;
                            else
                                state <= WALK_RIGHT;
                        end
                        fall_counter <= 6'b0;

                    end
                end
                DIGGING: begin
                    digging = 1;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                        fall = 1;
                        aaah <= "aaah!";
                    end
                end
            endcase
        end
    end
endmodule