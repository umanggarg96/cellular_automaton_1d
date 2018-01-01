module ca_core(clk, reset_n, sw, ack, debug_leds, load, ca_out);

    parameter N = 514;

    input  wire         clk;
    input  wire         reset_n;
    input  wire [3:0]   sw;
    input  wire         ack;

    output wire [7:0]   debug_leds;
    output wire         load;
    output wire [N-3:0] ca_out;

    localparam M = N - 1;

    reg  [9:0] index;
    wire [9:0] index_next;
    wire       out;
    wire       update;
    wire [2:0] in;

    reg [N-1:0] current_ca;
    reg [N-1:0] next_ca;

    always @(posedge clk)
        if(~reset_n)        index <= 10'd1;
        else                index <= index_next;

    always @(posedge clk)
        if(~reset_n)    current_ca <= ({{M{1'b0}}, 1'b1} << N / 2);
        else if(update) current_ca <= next_ca;

    always @(posedge clk)
        if(~reset_n)    next_ca <= 0;
        else            next_ca[index] <= out;

    ca_controller_fsm #(
            .N(N - 2)
        ) inst_ca_controller_fsm (
            .clk        (clk),
            .reset_n    (reset_n),
            .ack        (ack),
            .index      (index),
            .index_next (index_next),
            .update     (update),
            .load       (load)
        );

    input_function inst_input_function
        (
            .clk        (clk),
            .reset_n    (reset_n),
            .sw         (sw),
            .in         (in),
            .debug_leds (debug_leds),
            .out        (out)
        );
    assign in = {current_ca[index + 1], current_ca[index], current_ca[index - 1]};
    assign ca_out = current_ca[N-2:1];
endmodule
