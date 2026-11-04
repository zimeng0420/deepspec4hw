// Top Module
module top_module (
    // Inputs
    // Add Input Here
    ,
    // Outputs
    // Add Outputs Here
    ,
    // Inputs
    // Add Input Here
    ,
    // Outputs
    // Add Outputs Here
);

    // Internal signals
    // Add internal signals here

    // Instance the sub-modules here, if necessary

    // Combinational logic
    // (Based on the problem description, heater, aircon, fan are calculated here)
    // Assuming 'mode', 'too_cold', 'too_hot', 'fan_on' are inputs and 'heater', 'aircon', 'fan' are outputs
    input mode;
    input too_cold;
    input too_hot;
    input fan_on;

    output heater;
    output aircon;
    output fan;

    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = heater | aircon | fan_on;

endmodule