task run_test();
    begin
	
	$display("======================================");	
  	$display("====== APB check access ==============");
  	$display("======================================");	
	// normal case
	mst_wr(TDR0_ADDR,32'h11,STRB_FULL);
	mst_rd(TDR0_ADDR,rdata);
	cmp_data(rdata, 32'h11);

	// abnormal case
	// psel=0,penable=1
	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b0;
	tim_penable=1'b1;
	tim_pwrite = 1'b1;
	tim_paddr = TDR0_ADDR;
	tim_pwdata = 32'h11;
	tim_pstrb  = 4'b1111;
	
	repeat(3) @(posedge sys_clk);
	mst_rd(TDR0_ADDR, rdata);
	cmp_data(rdata, 32'h0);

	// psel=1,penable=0
	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b1;
	tim_penable=1'b0;
	tim_pwrite = 1'b1;
	tim_paddr = TDR0_ADDR;
	tim_pwdata = 32'h11;
	tim_pstrb  = 4'b1111;
	
	repeat(3) @(posedge sys_clk);
	mst_rd(TDR0_ADDR, rdata);
	cmp_data(rdata, 32'h0);
	
	$display("======================================");	
  	$display("====== APB check wait state ==========");
  	$display("======================================");	
	// check wait state
	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b1;
	tim_penable=1'b1;
	tim_pwrite = 1'b1;
	
	cmp_data(tim_pready,1'b0);
	@(posedge sys_clk); #1;
	cmp_data(tim_pready,1'b1);
	
	// check other case pready=0
	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b0;
	tim_penable=1'b1;
	@(posedge sys_clk); #1;
	cmp_data(tim_pready,1'b0);

	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b1;
	tim_penable=1'b0;
	@(posedge sys_clk); #1;
	cmp_data(tim_pready,1'b0);

	reset();
	@(posedge sys_clk); #1;
	tim_psel=1'b1;
	tim_penable=1'b1;
	@(posedge sys_clk); #1;
	tim_penable=1'b0; #1;
	cmp_data(tim_pready,1'b0);

	$display("======================================");	
  	$display("====== APB check multiple access =====");
  	$display("======================================");	
	mst_wr(TDR0_ADDR,32'h11,STRB_FULL);
	mst_wr(TDR0_ADDR,32'h22,STRB_FULL);
	mst_rd(TDR0_ADDR,rdata);
	mst_rd(TDR0_ADDR,rdata);
	cmp_data(rdata, 32'h22);

	mst_rd(TDR0_ADDR,rdata);
	mst_rd(TDR0_ADDR,rdata);
	mst_wr(TDR0_ADDR,32'h33,STRB_FULL);
	mst_wr(TDR0_ADDR,32'h44,STRB_FULL);
	mst_rd(TDR0_ADDR,rdata);
	cmp_data(rdata, 32'h44);


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end
endtask

