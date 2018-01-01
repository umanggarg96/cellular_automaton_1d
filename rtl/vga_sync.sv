module vga_sync (h_sync, v_sync, video_on, pixel_tick, pixel_x, pixel_y, clk, reset_n);

	input  wire 		clk;
	input  wire 		reset_n;

	output wire 		h_sync;
	output wire 		v_sync;
	output wire			video_on;
	output reg 			pixel_tick;
	output wire [10:0] 	pixel_x, pixel_y;

	localparam HD = 640;
	localparam HF = 48;
	localparam HB = 16;
	localparam HR = 96;
	localparam VD = 480;
	localparam VF = 10;
	localparam VB = 33;
	localparam VR = 2;


	reg [10:0] h_counter_reg,h_counter_next;
	reg [10:0] v_counter_reg,v_counter_next;

	reg v_sync_reg,h_sync_reg;
	wire v_sync_next,h_sync_next;

	wire h_end,v_end;

    always @(posedge clk)
        if(~reset_n)    pixel_tick <= 1'b0;
        else            pixel_tick <= ~pixel_tick;

	always @(posedge clk)
	begin
		if(~reset_n)
		begin
			v_counter_reg <= 0;
			h_counter_reg <= 0;
			v_sync_reg <= 1'b0;
			h_sync_reg <= 1'b0;
		end
		else
		begin
			v_counter_reg <= v_counter_next;
			h_counter_reg <= h_counter_next;
			v_sync_reg <= v_sync_next;
			h_sync_reg <= h_sync_next;
		end
	end

	assign h_end = (h_counter_reg == (HD + HF + HB + HR - 1));
	assign v_end = (v_counter_reg == (VD + VF + VB + VR - 1));

	always @*
		if(pixel_tick)
			if(h_end)
				h_counter_next = 0;
			else
				h_counter_next = h_counter_reg + 1;
		else
			h_counter_next = h_counter_reg;

	always @*
		if(pixel_tick & h_end)
			if(v_end)
				v_counter_next = 0;
			else
				v_counter_next = v_counter_reg + 1;
		else
			v_counter_next = v_counter_reg;


	assign h_sync_next = (h_counter_reg >= (HD + HB) && h_counter_reg <= (HD + HB + HR - 1));
	assign v_sync_next = (v_counter_reg >= (VD + VB) && v_counter_reg <= (VD + VB + VR - 1));

    //output signals
    assign video_on = (h_counter_reg < HD) && (v_counter_reg < VD);
	assign h_sync = h_sync_reg;
	assign v_sync = v_sync_reg;
	assign pixel_x = h_counter_reg;
	assign pixel_y = v_counter_reg;
endmodule
