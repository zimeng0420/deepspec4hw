module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    parameter IDLE = 3'b000;
    parameter DETECT = 3'b001;
    parameter CAPTURE = 3'b010;
    parameter COUNTING = 3'b011;
    parameter DONE_STATE = 3'b100;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [12:0] counter;  // (delay + 1) * 1000, max delay = 15,  so max count = 16000
    reg [3:0] count_internal;
    wire start_detected;


    // Start Sequence Detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_detected = (shift_reg == 4'b1101);

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            counter <= 13'd0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (start_detected) begin
                        state <= DETECT;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT: begin
                    state <= CAPTURE;
                end
                CAPTURE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    state <= COUNTING;

                end
                COUNTING: begin
                   counting <= 1'b1;
                   done <= 1'b0;
                   if (counter == 0) {
                       state <= DONE_STATE;
                   }
                   else
                   begin
                       state <= COUNTING;
                   end
                end
                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                       state <= IDLE;
                    end else begin
                        state <= DONE_STATE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
    // Delay Capture
     always @(posedge clk) begin
        if (reset) begin
            delay <= 4'b0000;
        end else begin
            if (state == DETECT) begin
                delay <= {data, data, data, data};
            end
        end
    end
        // Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 13'd0;
        end else begin
            case (state)
                IDLE: begin
                    counter <= 13'd0;
                end
                DETECT: begin
                    counter <= ((delay + 1) * 1000);
                end
                CAPTURE: begin
                     counter <= ((delay + 1) * 1000);
                end
                COUNTING: begin
                     counter <= counter - 1'b1;
                end
                DONE_STATE: begin
                     counter <= 13'd0;
                end
                default: counter <= 13'd0;
            endcase
        end
    end


    // Count output logic
    always @(*) begin
        if (state == COUNTING) begin
            count_internal = counter[12:9]; // to mimic decrementing by 1000 each time.
        end else begin
            count_internal = 4'b0;  // Or don't care or any other value
        end
    end

    assign count = count_internal;

endmodule