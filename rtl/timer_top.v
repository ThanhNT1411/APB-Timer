module timer_top (
	input  wire sys_clk,
	input  wire sys_rst_n,
	input  wire tim_psel,
	input  wire tim_penable,
	input  wire tim_pwrite,
	input  wire [11:0] tim_paddr,
	input  wire [31:0] tim_pwdata,
	input  wire [3:0]  tim_pstrb,
	output wire [31:0] tim_prdata,
	output wire tim_pslverr,
	output wire tim_pready,
	output wire tim_int,
	input  wire dbg_mode
);
	//apb slave
	wire wr_en;
	wire rd_en;

	//counter
	wire timer_en;
	wire div_en;
	wire [3:0]  div_val;
	wire [63:0] cnt_tdr;
	wire cnt_tdr_en;
	wire cnt_clr;
	wire timer_en_nedge;
	wire [63:0] count;
	wire cnt_update;
	wire halt_en;


	apb_slave apb_slave_u(
		.sys_clk        (sys_clk        ),
		.sys_rst_n      (sys_rst_n      ),
		.tim_psel       (tim_psel       ),
		.tim_penable    (tim_penable    ),
		.tim_pwrite     (tim_pwrite     ),
		.tim_pready     (tim_pready     ),
		.wr_en          (wr_en          ),
		.rd_en          (rd_en          )
	);	

	register register_u (
		.sys_clk        (sys_clk        ),
		.sys_rst_n      (sys_rst_n      ),
		.wr_en          (wr_en          ),
		.rd_en          (rd_en          ),
		.tim_paddr      (tim_paddr      ),
		.tim_pwdata     (tim_pwdata     ),
		.tim_prdata     (tim_prdata     ),
		.tim_pstrb      (tim_pstrb      ),
		.tim_pslverr    (tim_pslverr    ),
		.tim_int        (tim_int        ),
		.dbg_mode       (dbg_mode       ),
		//connect to counter
		.timer_en       (timer_en       ),
		.div_en         (div_en         ),
		.div_val        (div_val        ),
		.cnt_tdr        (cnt_tdr        ),
		.cnt_tdr_en     (cnt_tdr_en     ),	
		.cnt_clr        (cnt_clr        ),
		.timer_en_nedge (timer_en_nedge ),
		.count          (count          ),
		.cnt_update     (cnt_update     ),
		.halt_en        (halt_en        )
	);

	counter counter_u (
		.sys_clk        (sys_clk        ),
		.sys_rst_n      (sys_rst_n      ),
		.timer_en       (timer_en       ),
		.div_en         (div_en         ),
		.div_val        (div_val        ),
		.cnt_tdr        (cnt_tdr        ),
		.cnt_tdr_en     (cnt_tdr_en     ),	
		.timer_en_nedge (timer_en_nedge ),
		.cnt_clr        (cnt_clr        ),
		.count          (count          ),
		.cnt_update     (cnt_update     ),
		.halt_en        (halt_en        )
	);

endmodule
