`default_nettype none

module cellular_automaton_1d(clk, reset_n, sw, key, debug_leds, h_sync, v_sync, rgb);

    input  wire         clk;
    input  wire         reset_n;
    input  wire [3:0]   sw;
    input  wire         key;

    output wire [7:0]   debug_leds;
    output wire         h_sync;
    output wire         v_sync;
    output wire [2:0]   rgb;

    wire            ack;
    wire            load;
    wire [511:0]    ca_out;
    wire            video_on;
    wire [12:0]     word_addr;
    wire [3:0]      bit_addr;
    wire [4:0]      col;
    wire [7:0]      row;
    wire            load_mem;
    wire [15:0]     in_a;
    wire [15:0]     vga_word;

    ca_core #(
            .N(514)
        ) inst_ca_core (
            .clk        (clk),
            .reset_n    (reset_n),
            .sw         (sw),
            .ack        (ack),
            .debug_leds (debug_leds),
            .load       (load),
            .ca_out     (ca_out)
        );

    //port A - used by vga_contoller_fsm to copy automaton data to buffer memory
    //port B - used by vga_driver to read word for the screen
    vga_buffer inst_vga_buffer
        (
            .clk    (clk),
            .addr_a ({row, col}),
            .addr_b (word_addr),
            .load_a (load_mem),
            .in_a   (in_a),
            .in_b   (0),
            .load_b (0),
            // .out_a  (out_a),//NOTCONNETED
            .out_b  (vga_word)
        );

    vga_driver inst_vga_driver (
            .clk       (clk),
            .reset_n   (reset_n),
            .v_sync    (v_sync),
            .h_sync    (h_sync),
            .video_on  (video_on),
            .word_addr (word_addr),
            .bit_addr  (bit_addr)
        );

    vga_controller_fsm inst_vga_controller_fsm
        (
            .clk      (clk),
            .reset_n  (reset_n),
            .load     (load),
            .key      (key),
            .col      (col),
            .row      (row),
            .ack      (ack),
            .load_mem (load_mem)
        );

    assign in_a = {ca_out[511 - {col, 4'h0}],
                   ca_out[510 - {col, 4'h0}],
                   ca_out[509 - {col, 4'h0}],
                   ca_out[508 - {col, 4'h0}],
                   ca_out[507 - {col, 4'h0}],
                   ca_out[506 - {col, 4'h0}],
                   ca_out[505 - {col, 4'h0}],
                   ca_out[504 - {col, 4'h0}],
                   ca_out[503 - {col, 4'h0}],
                   ca_out[502 - {col, 4'h0}],
                   ca_out[501 - {col, 4'h0}],
                   ca_out[500 - {col, 4'h0}],
                   ca_out[499 - {col, 4'h0}],
                   ca_out[498 - {col, 4'h0}],
                   ca_out[497 - {col, 4'h0}],
                   ca_out[496 - {col, 4'h0}]};

    assign rgb = video_on ? {3{vga_word[bit_addr]}} : 3'b000;
endmodule
