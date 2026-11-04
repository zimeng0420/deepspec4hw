module top_module (
    input cpu_overheated,
    output reg shut_off_computer,
    input arrived,
    input gas_tank_empty,
    output reg keep_driving
);

    // Always block to evaluate the cpu_overheated signal
    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1; // Shut off the computer if overheating
        end else begin
            shut_off_computer = 0; // Otherwise, ensure computer is not shut off
        end
    end

    // Always block to evaluate travel conditions
    always @(*) begin
        if (~arrived) begin
            keep_driving = ~gas_tank_empty; // Keep driving if not arrived and gas tank is not empty
        end else begin
            keep_driving = 0; // If arrived, stop driving
        end
    end

endmodule