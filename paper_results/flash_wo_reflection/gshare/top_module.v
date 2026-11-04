module top_module(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 128-entry PHT (2-bit saturating counters)
    reg [1:0] pht [127:0];

    // 7-bit global branch history register
    reg [6:0] global_history;

    // Internal signals
    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire same_index;
    reg [1:0] pht_read_value;
    reg [1:0] pht_write_value;

    // Calculate PHT indices
    assign predict_index = predict_pc ^ global_history;
    assign train_index = train_pc ^ train_history;

    // Check if prediction and training access the same PHT entry
    assign same_index = (predict_valid && train_valid) && (predict_index == train_index);

    // PHT read logic (combinational)
    always @(*) begin
        pht_read_value = pht[predict_index];
    end

    // Prediction logic (combinational)
    always @(*) begin
        predict_history = global_history;
        if (predict_valid) begin
            predict_taken = pht_read_value[1]; // MSB of the counter
        end else begin
            predict_taken = 0; // Default value when not valid
        end
    end

    // Training logic (sequential)
    always @(posedge clk) begin
        if (areset) begin
            // Reset PHT and global history
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00; // Weakly not taken
            end
            global_history <= 7'b0;
        end else begin
            // Update PHT
            if (train_valid) begin
                // Determine the new PHT value based on train_taken
                if (train_taken) begin
                    case (pht[train_index])
                        2'b00: pht_write_value = 2'b01;
                        2'b01: pht_write_value = 2'b10;
                        2'b10: pht_write_value = 2'b11;
                        2'b11: pht_write_value = 2'b11;
                        default: pht_write_value = 2'b11;
                    endcase
                end else begin
                    case (pht[train_index])
                        2'b00: pht_write_value = 2'b00;
                        2'b01: pht_write_value = 2'b00;
                        2'b10: pht_write_value = 2'b01;
                        2'b11: pht_write_value = 2'b10;
                        default: pht_write_value = 2'b00;
                    endcase
                end
                pht[train_index] <= pht_write_value;
            end

            // Update global history register
            if (train_valid && train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

endmodule