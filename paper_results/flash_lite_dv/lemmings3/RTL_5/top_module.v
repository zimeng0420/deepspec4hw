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

    // State Definition
    parameter IDLE = 2'b00;
    parameter WALKING_LEFT = 2'b01;
    parameter WALKING_RIGHT = 2'b10;
    parameter DIGGING = 2'b11;

    // State Register
    reg [1:0] state;

    // Combinational Logic for Outputs and Next State
    always @(*) begin
        aaah = 1'b0;
        digging = 1'b0;
        walk_left = 1'b0;
        walk_right = 1'b0;

        case (state)
            IDLE: begin
                if (!ground) begin
                    aaah = 1'b1;
                end
                else if (dig) begin
                    digging = 1'b1;
                end
                else if (bump_left) begin
                    walk_right = 1'b1;
                end
                else if (bump_right) begin
                    walk_left = 1'b1;
                end
                else
                begin
                   walk_left = 1'b1;
                end
            end
            WALKING_LEFT: begin
                if (!ground) begin
                    aaah = 1'b1;
                end
                else if (dig && ground) begin
                    digging = 1'b1;
                end
                else if (bump_right) begin
                    walk_right = 1'b1;
                end
                else if (bump_left) begin
                    walk_right = 1'b1;
                end
                else begin
                    walk_left = 1'b1;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    aaah = 1'b1;
                end
                else if (dig && ground) begin
                   digging = 1'b1;
                end
                else if (bump_left) begin
                    walk_left = 1'b1;
                end
                 else if (bump_right) begin
                    walk_left = 1'b1;
                end
                else begin
                    walk_right = 1'b1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                   aaah = 1'b1;
                end
                else
                begin
                  digging = 1'b1;
                  if(bump_left)
                     walk_right = 1'b1;
                   else if (bump_right)
                     walk_left = 1'b1;
                   else if (dig)
                      digging = 1'b1;
                  else if(state == DIGGING)
                      ;
                  else
                    ;
                end
            end
           default: begin
                walk_left = 1'b1;
            end
        endcase
    end

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
        end else begin
            if (!ground) begin
              if(state == DIGGING)
                 state <= WALKING_LEFT;
            end
            else begin
               if (digging)
                state <= DIGGING;
               else if (walk_left && !bump_right)
                 state <= WALKING_LEFT;
                else if (walk_right && !bump_left)
                 state <= WALKING_RIGHT;
               else if (walk_left && bump_right)
                state <= WALKING_RIGHT;
               else if (walk_right && bump_left)
                 state <= WALKING_LEFT;
               else if(walk_left && bump_right && bump_left)
                   state <= WALKING_RIGHT;
               else if(walk_right && bump_right && bump_left)
                  state <= WALKING_LEFT;
               else if(walk_left && bump_left)
                   state <= WALKING_RIGHT;
               else if(walk_right && bump_right)
                    state <= WALKING_LEFT;
               else if(dig && ground && state != DIGGING)
                 state <= DIGGING;
               else if (state != DIGGING && !digging)
                   state <= state;
               else
                  state <= state;
            end

         end
    end

endmodule