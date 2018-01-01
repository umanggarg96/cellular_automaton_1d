/*
    640x480
    ------------------------------------    640 - 512 = 128
    |                                  |    128 / 2 = 64 => horizontal shift
    |       512x256                    |    480 - 256 = 224
    |       X------------------        |    224 / 2 = 112 => vertical shift
    |       |                 |        |
    |<-64-->|                 |        |    point X => (64,112)
    |       |                 |        |    point Y => (64 + 512, 112 + 256)
    |       |                 |        |            => (576, 368)
    |       ------------------Y        |
    |          ^                       |
    |          | 112                   |
    ------------------------------------

    I/O :
    clk - clock to the system
    reset_n - sync active low reset
    v_sync - vertical sync pulse for the VGA interface
    h_sync - horizontal sync pulse for the VGA interface
    video_on - high when the pixels have to be written on the screen
    word_addr - 13 bit address to select the memory word from the vga_buffer
                memory
    bit_addr - 4 bit address to select the bit from the memory word fetched from
               vga_buffer with the word_addr

*/
module vga_driver(clk, reset_n, v_sync, h_sync, video_on, word_addr, bit_addr);

    input  wire         clk;
    input  wire         reset_n;

    output wire         v_sync;
    output wire         h_sync;
    output wire         video_on;

    output wire [12:0]  word_addr;
    output wire [3:0]   bit_addr;

    parameter [10:0] UPPER_X = 11'd576, UPPER_Y = 11'd368; //pointY
    parameter [10:0] LOWER_X = 11'd64,  LOWER_Y = 11'd112; //pointX

    wire [10:0] pixel_x, adjusted_x;
    wire [10:0] pixel_y, adjusted_y;

    vga_sync inst_vga_sync (
            .clk     (clk),
            .reset_n (reset_n),
            .h_sync  (h_sync),
            .v_sync  (v_sync),
            .pixel_x (pixel_x),
            .pixel_y (pixel_y)
            // .video_on(video_on) // NOT CONNECTED
            // .p_tick  (p_tick)   // NOT CONNECTED
        );


    assign video_on = pixel_x >= LOWER_X && pixel_x <= UPPER_X && pixel_y <= UPPER_Y && pixel_y >= LOWER_Y;

    assign adjusted_x = pixel_x - 10'd64;
    assign adjusted_y = pixel_y - 10'd112;

    assign word_addr = {adjusted_y[7:0], adjusted_x[8:4]};
    assign bit_addr  = ~adjusted_x[3:0];

endmodule
