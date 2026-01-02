module counter (
	input  wire sys_clk,
	input  wire sys_rst_n,
	input  wire timer_en,
	input  wire div_en,
	input  wire [3:0]  div_val,
	input  wire [63:0] cnt_tdr,
	input  wire cnt_tdr_en,
	input  wire cnt_clr,
	input  wire timer_en_nedge,
	input  wire halt_en,
	output reg  [63:0] count,
	output reg  cnt_update
);
	// declare for main counter
	reg  [63:0] cnt_pre;
	wire cnt_en;
	wire pulse;

	// declare for sub counter
	reg  [7:0]  sub_cnt;
	wire [7:0]  sub_cnt_pre;
	reg  [7:0]  sub_cnt_cmp;
	wire sub_cnt_clr;
	wire sub_cnt_en;


	// Main counter
	assign cnt_en = ~halt_en && timer_en && (!div_en || (div_val==0) || pulse );
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			cnt_update <= 1'b0;
		end else begin
			cnt_update <= cnt_en;
		end
	end

	always @(*) begin
		if( ((cnt_clr & cnt_en) | timer_en_nedge) & (~halt_en) ) begin
			cnt_pre = 64'h0;
		end else begin
			if (cnt_tdr_en) begin
				cnt_pre = cnt_tdr;
			end else begin
				if (cnt_en) begin
					cnt_pre = count + 1;
				end else begin
					cnt_pre = count;
				end
			end
		end
	end

	// D.F.F of main counter
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			count <= 64'b0;
		end else begin
			count <= cnt_pre;
		end
	end


	// Sub counter
	
	// choose mode
	always @(*) begin
		case (div_val)
			4'h0: sub_cnt_cmp = 8'd0;
			4'h2: sub_cnt_cmp = 8'd3;
			4'h3: sub_cnt_cmp = 8'd7;
			4'h4: sub_cnt_cmp = 8'd15;
			4'h5: sub_cnt_cmp = 8'd31;
			4'h6: sub_cnt_cmp = 8'd63;
			4'h7: sub_cnt_cmp = 8'd127;
			4'h8: sub_cnt_cmp = 8'd255;
			default: sub_cnt_cmp = 8'd1;
		endcase
	end

	assign pulse       = sub_cnt == sub_cnt_cmp;
	assign sub_cnt_pre = sub_cnt_clr ? 8'h0 : sub_cnt_en ? sub_cnt+1 : sub_cnt;
	assign sub_cnt_clr = ~halt_en & (~timer_en | ~div_en | pulse);
	assign sub_cnt_en  = ~halt_en & timer_en & div_en & (div_val!=0);

	// D.F.F of sub counter
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			sub_cnt <= 8'b0;
		end else begin
			sub_cnt <= sub_cnt_pre;
		end
	end
endmodule
