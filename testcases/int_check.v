task run_test();
    begin
	$display("======================================");	
  	$display("====== Interrupt enable check ========");
  	$display("======================================");
	// tim_en = 1
	mst_wr(TIER_ADDR , 32'h0000_0001, STRB_FULL);
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(6);
        cnt_cmp_data(tim_int, 1);
	
	$display("======================================");	
  	$display("====== Interrupt enable check ========");
  	$display("======================================");
	// tim_en = 0
	reset();
	mst_wr(TIER_ADDR , 32'h0000_0000, STRB_FULL);
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(6);
        cnt_cmp_data(tim_int, 0);
	
	$display("======================================");	
  	$display("====== Interrupt check occurred ======");
  	$display("======================================");
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(5);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 1);
	
	$display("======================================");	
  	$display("====== Interrupt still occurred ======");
  	$display("======================================");
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(8);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 1);

	$display("======================================");	
  	$display("= No affect when interrupt occurred ==");
  	$display("======================================");
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(8);
	mst_wr(TISR_ADDR , 32'h0000_0000, STRB_FULL);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 1);

	$display("======================================");	
  	$display("====== Write 1 to clear interrupt ====");
  	$display("======================================");
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(8);
	mst_wr(TISR_ADDR , 32'h0000_0001, STRB_FULL);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("=No affect when no interrupt occurred=");
  	$display("======================================");
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_000f, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(8);
	mst_wr(TISR_ADDR , 32'h0000_0001, STRB_FULL);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Check piority =================");
  	$display("======================================");
	reset();
	mst_wr(TIER_ADDR , 32'h0000_0001, STRB_FULL);
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(3);
	mst_wr(TISR_ADDR , 32'h0000_0001, STRB_FULL);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("= Timer continue count when interrupt=");
  	$display("======================================");
	reset();
	mst_wr(TIER_ADDR , 32'h0000_0001, STRB_FULL);
	mst_wr(TCMP0_ADDR, 32'h0000_0005, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(8);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 3);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask

