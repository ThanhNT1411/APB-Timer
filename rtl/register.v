module register (
	input  wire sys_clk,
	input  wire sys_rst_n,
	input  wire wr_en,
	input  wire rd_en,
	input  wire [11:0] tim_paddr,
	input  wire [31:0] tim_pwdata,
	input  wire [3:0]  tim_pstrb,
	output reg  [31:0] tim_prdata,
	output wire tim_pslverr,
	output wire tim_int,
	input  wire dbg_mode,

	// connect to counter
	input  wire cnt_update,
	input  wire [63:0] count,
	output wire timer_en,
	output wire div_en,
	output wire [3:0]  div_val,
	output wire [63:0] cnt_tdr,
	output wire cnt_tdr_en,
	output wire cnt_clr,
	output wire timer_en_nedge,
	output wire halt_en
);
	// register
	reg  [31:0] TCR_reg;
	reg  [31:0] TDR0_reg;
	reg  [31:0] TDR1_reg;
	reg  [31:0] TCMP0_reg;
	reg  [31:0] TCMP1_reg;
	reg  [31:0] TIER_reg;
	reg  [31:0] TISR_reg;
	reg  [31:0] THCSR_reg;

	wire [5:0]  TCR_pre;
	reg  [31:0] TDR0_pre;
	reg  [31:0] TDR1_pre;
	wire [31:0] TCMP0_pre;
	wire [31:0] TCMP1_pre;
	wire THCSR_pre;
	wire TIER_pre;
	wire TISR_pre;
	
	wire TCR_sel0;
	wire TCR_sel1;
	wire TDR0_sel;
	wire TDR1_sel;
	wire TCMP0_sel;
	wire TCMP1_sel;
	wire TIER_sel;
	wire TISR_clr;
	wire TISR_set;
	wire THCSR_sel;

	wire prohibit_err;
	wire div_en_err;
	wire div_val_err;
	reg  timer_en_next;

	// function generate data to be written
	function [31:0] strobe_merge;
		input [3:0]  pstrb;
		input [31:0] pwdata;
		input [31:0] data_reg;
		reg   [31:0] mask;
		begin
			// mask to write byte strobes      
			mask = {{8{pstrb[3]}},
				{8{pstrb[2]}},
				{8{pstrb[1]}},
				{8{pstrb[0]}}};

			strobe_merge = (pwdata & mask) | (data_reg & (~mask));
		end
	endfunction

      	// connect to counter      
	assign timer_en    = TCR_reg[0];
	assign div_en      = TCR_reg[1];
	assign div_val     = TCR_reg[11:8];
	assign cnt_tdr     = {TDR1_pre,TDR0_pre};
	assign cnt_tdr_en  = TDR0_sel | TDR1_sel;
	assign cnt_clr     = TISR_set;
	assign halt_en     = dbg_mode & THCSR_reg[0];

	// assert interrupt
	assign tim_int     = TIER_reg[0] & TISR_reg[0];

	// Check Error TCR reg
	assign div_en_err  = TCR_sel0 & TCR_reg[0] & (TCR_reg[1] !== tim_pwdata[1]);
	assign div_val_err = TCR_sel1 & TCR_reg[0] & (TCR_reg[11:8] !== tim_pwdata[11:8]);
	assign prohibit_err= TCR_sel1 & (tim_pwdata[11:8]>4'h8);
	assign tim_pslverr = div_en_err | div_val_err | prohibit_err;



	// write data to register
	// TCR
	assign TCR_sel0     = wr_en & (tim_paddr === 12'h0) & tim_pstrb[0];
	assign TCR_sel1     = wr_en & (tim_paddr === 12'h0) & tim_pstrb[1];
	assign TCR_pre[1:0] = TCR_sel0 & ~tim_pslverr ? tim_pwdata[1:0]  : TCR_reg[1:0];
	assign TCR_pre[5:2] = TCR_sel1 & ~tim_pslverr ? tim_pwdata[11:8] : TCR_reg[11:8];
	
	// negative edge of timer_en (H->L)
	assign timer_en_nedge = timer_en_next & (~timer_en);
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			timer_en_next <= 1'b0;
		end else begin
			timer_en_next <= timer_en;
		end
	end
	// TDR0	
	assign TDR0_sel = wr_en & (tim_paddr === 12'h4);
	always @(*) begin
		if(TDR0_sel) begin
			TDR0_pre = strobe_merge(tim_pstrb,tim_pwdata,TDR0_reg);
		end else begin
			if (timer_en_nedge) begin
				TDR0_pre = 32'h0;
			end else begin
				if (cnt_update) begin
					TDR0_pre = count[31:0];
				end else begin
					TDR0_pre = TDR0_reg;
				end
			end
		end
	end

	
	// TDR1
	assign TDR1_sel  = wr_en & (tim_paddr === 12'h8);
	always @(*) begin
		if(TDR1_sel) begin
			TDR1_pre = strobe_merge(tim_pstrb,tim_pwdata,TDR1_reg);
		end else begin
			if (timer_en_nedge) begin
				TDR1_pre = 32'h0;
			end else begin
				if (cnt_update) begin
					TDR1_pre = count[63:32];
				end else begin
					TDR1_pre = TDR1_reg;
				end
			end
		end
	end


	// TCMP0
	assign TCMP0_sel = wr_en & (tim_paddr === 12'hC);
	assign TCMP0_pre = TCMP0_sel ? strobe_merge(tim_pstrb,tim_pwdata,TCMP0_reg) : TCMP0_reg;
	
	// TCMP1
	assign TCMP1_sel = wr_en & (tim_paddr === 12'h10);
	assign TCMP1_pre = TCMP1_sel ? strobe_merge(tim_pstrb,tim_pwdata,TCMP1_reg) : TCMP1_reg;
	
	// TIER
	assign TIER_sel  = wr_en & tim_pstrb[0] & (tim_paddr === 12'h14);
	assign TIER_pre  = TIER_sel ? tim_pwdata[0] : TIER_reg[0];
	
	//TISR
	assign TISR_clr  = wr_en & tim_pstrb[0] & tim_pwdata[0] & (tim_paddr === 12'h18);
	assign TISR_set  = count === {TCMP1_reg,TCMP0_reg};
	assign TISR_pre  = TISR_clr ? 1'b0 : ( TISR_set ? 1'b1 : TISR_reg[0]);
	
	// THCSR
	assign THCSR_sel    = wr_en & tim_pstrb[0] & (tim_paddr === 12'h1C);
	assign THCSR_pre    = THCSR_sel ? tim_pwdata[0] : THCSR_reg[0];



	// Read data from register	
	always @(*) begin
		if (rd_en) begin
			case (tim_paddr)
				12'h00: tim_prdata = TCR_reg;
				12'h04: tim_prdata = TDR0_reg;
				12'h08: tim_prdata = TDR1_reg;
				12'h0C: tim_prdata = TCMP0_reg;
				12'h10: tim_prdata = TCMP1_reg;
				12'h14: tim_prdata = TIER_reg;
				12'h18: tim_prdata = TISR_reg;
				12'h1C: tim_prdata = THCSR_reg;
				default: tim_prdata = 32'h0;
			endcase
		end else begin
			tim_prdata = 32'h0;
		end
	end



	// D.F.F register TCR 
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TCR_reg <= 32'h0000_0100;
		end else begin
			TCR_reg[1:0]  <= TCR_pre[1:0];
			TCR_reg[11:8] <= TCR_pre[5:2];
		end
	end
	
	// D.F.F register TDR0
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TDR0_reg <= 32'h0;
		end else begin
			TDR0_reg <= TDR0_pre;
		end
	end

	// D.F.F register TDR1
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TDR1_reg <= 32'h0;
		end else begin
			TDR1_reg <= TDR1_pre;
		end
	end

	// D.F.F register TCMP0
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TCMP0_reg <= 32'hFFFF_FFFF;
		end else begin
			TCMP0_reg <= TCMP0_pre;
		end
	end

	// D.F.F register TCMP1
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TCMP1_reg <= 32'hFFFF_FFFF;
		end else begin
			TCMP1_reg <= TCMP1_pre;
		end
	end

	// D.F.F register TIER
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TIER_reg <= 32'h0;
		end else begin
			TIER_reg[0] <= TIER_pre;
		end
	end

	// D.F.F register TISR
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			TISR_reg <= 32'h0;
		end else begin
			TISR_reg[0] <= TISR_pre;
		end
	end

	// D.F.F register THCSR
	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			THCSR_reg <= 32'h0;
		end else begin
			THCSR_reg[0] <= THCSR_pre;
			THCSR_reg[1] <= dbg_mode & THCSR_reg[0];
		end
	end

endmodule
