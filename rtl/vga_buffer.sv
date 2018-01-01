module vga_buffer(clk, addr_a, addr_b, load_a, in_a, in_b, load_b, out_a, out_b);

    input  wire         clk;
    input  wire [12:0]  addr_a;
    input  wire [12:0]  addr_b;
    input  wire         load_a;
    input  wire         load_b;
    input  wire [15:0]  in_a;
    input  wire [15:0]  in_b;

    output wire [15:0]  out_a;
    output wire [15:0]  out_b;

    reg [15:0] mem [0:8191];

    reg [12:0] read_addr_a;
    reg [12:0] read_addr_b;

    always @(posedge clk)
    begin
        read_addr_a <= addr_a;
        if(load_a) mem[addr_a] <= in_a;
    end

    always @(posedge clk)
    begin
        read_addr_b <= addr_b;
        if(load_b)  mem[addr_b] <= in_b;
    end

    assign out_a = mem[read_addr_a];
    assign out_b = mem[read_addr_b];

endmodule
