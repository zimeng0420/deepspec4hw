module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [1:0] count;

    localparam IDLE = 2'd0,
               HEADER = 2'd1,
               RECEIVE = 2'd2;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    count <= 0;
                    if (in[3] == 1) begin
                        state <= HEADER;
                    end
                end
                
                HEADER: begin
                    out_bytes[23:16] <= in; // Store the first byte
                    count <= count + 1;
                    state <= RECEIVE;
                end
                
                RECEIVE: begin
                    case (count)
                        1: out_bytes[15:8] <= in; // Store the second byte
                        2: begin
                            out_bytes[7:0] <= in; // Store the third byte
                            done <= 1; // Signal done after receiving the third byte
                            count <= 0; // Reset count for the next message
                            state <= IDLE; // Return to IDLE state
                        end
                    endcase
                    if (count < 2) begin
                        count <= count + 1; // Increment count for the bytes received
                    end
                end

                default: state <= IDLE; // Safety net
            endcase

            // Reset the done signal for the next clock cycle unless counting
            if (state !== RECEIVE || (state == RECEIVE && count == 2)) begin
                done <= 0;
            end
        end
    end
endmodule