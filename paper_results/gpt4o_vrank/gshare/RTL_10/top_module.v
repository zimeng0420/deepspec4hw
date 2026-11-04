module top_module(
    input clk,
    input areset, 

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken, 
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history, 
    input [6:0] train_pc
);

    reg [6:0] global_history;
    reg [1:0] PHT [0:127]; // 128-entry table of two-bit saturating counters

    // Saturating counter logic
    function [1:0] update_counter;
        input [1:0] counter;
        input taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    update_counter = counter + 1;
                else
                    update_counter = counter;
            end else begin
                if (counter != 2'b00)
                    update_counter = counter - 1;
                else
                    update_counter = counter;
            end
        end
    endfunction

    wire [6:0] index = predict_pc ^ global_history; // XOR to get index
    wire [6:0] train_index = train_pc ^ train_history;

    assign predict_history = global_history;
    assign predict_taken = PHT[index][1]; // MSB defines taken (strongly/weakly taken)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
        end else begin
            // Training takes priority
            if (train_valid) begin
                PHT[train_index] <= update_counter(PHT[train_index], train_taken);
                if (train_mispredicted) begin
                    global_history <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    global_history <= {global_history[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

endmodule