module input_function(clk, reset_n, sw, in, debug_leds, out);

    input  wire         clk;
    input  wire         reset_n;
    input  wire [3:0]   sw;
    input  wire [2:0]   in;

    output wire [7:0]   debug_leds;
    output wire         out;

    reg [7:0] function_reg;

    always @(posedge clk)
        if(~reset_n)
            case(sw[1:0])
                2'b00: function_reg <= 8'd30;
                2'b01: function_reg <= 8'd54;
                2'b10: function_reg <= 8'd60;
                2'b11: function_reg <= 8'd182;
            endcase

    assign out = function_reg[in];
    assign debug_leds = function_reg;

endmodule
