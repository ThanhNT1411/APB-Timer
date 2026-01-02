module apb_slave (
	input  wire sys_clk,
	input  wire sys_rst_n,
	input  wire tim_psel,
	input  wire tim_penable,
	input  wire tim_pwrite,
	output wire tim_pready,
	output wire wr_en,
	output wire rd_en
);
	reg  apb_access;
	wire apb_access_pre;

	assign wr_en          = tim_pready  & tim_pwrite;
	assign rd_en          = tim_pready  & ~tim_pwrite;
	assign tim_pready     = apb_access  & tim_penable;
	assign apb_access_pre = tim_penable & tim_psel;

	always @(posedge sys_clk, negedge sys_rst_n) begin
		if (!sys_rst_n) begin
			apb_access <= 1'b0;
		end else begin
			apb_access <= apb_access_pre;
		end
	end

endmodule
