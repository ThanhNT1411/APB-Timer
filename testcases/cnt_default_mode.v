task run_test();
    begin
	$display("======================================");	
  	$display("====== Counter check init value ======");
  	$display("======================================");	
	reset();
        mst_rd(TDR0_ADDR, rdata);
        cmp_data(rdata, 32'h0);
        mst_rd(TDR1_ADDR, rdata);
        cmp_data(rdata, 32'h0);
	
	mst_wr(TCR_ADDR, 32'h1, STRB_FULL);
	wait_cycles(5);

	reset();
	mst_rd(TDR0_ADDR, rdata);
        cmp_data(rdata, 32'h0);
        mst_rd(TDR1_ADDR, rdata);
        cmp_data(rdata, 32'h0);

	$display("======================================");	
  	$display("====== Counter check default mode ====");
  	$display("======================================");
	//counter enable
	mst_wr(TCR_ADDR, 32'h0001, STRB_FULL);
	wait_cycles(19);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cmp_data(rdata, 20);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cmp_data(rdata, 0);
	
	$display("======================================");	
  	$display("====== Counter check overflow TDR0 ===");
  	$display("======================================");
	reset();
	mst_wr(TDR0_ADDR, 32'hffff_fff0, STRB_FULL);
	mst_wr(TDR1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR , 32'h0000_0001, STRB_FULL);
	wait_cycles(15);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 1);

	$display("======================================");	
  	$display("====== Counter check overflow TDR1 ===");
  	$display("======================================");
	reset();
	mst_wr(TDR0_ADDR, 32'hffff_fffe, STRB_FULL);
	mst_wr(TDR1_ADDR, 32'hffff_ffff, STRB_FULL);
	mst_wr(TCR_ADDR , 32'h0000_0001, STRB_FULL);
	wait_cycles(1);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("======================================");	
  	$display("====== Counter check load value ======");
  	$display("======================================");
	reset();
	mst_wr(TDR0_ADDR, 32'h05, STRB_FULL);
	mst_wr(TDR1_ADDR, 32'h00, STRB_FULL);
	mst_wr(TCR_ADDR , 32'h01, STRB_FULL);
	wait_cycles(59);
	cnt_mst_rd(TDR0_ADDR,rdata);
        cnt_cmp_data(rdata, 65);
        cnt_mst_rd(TDR1_ADDR,rdata);
        cnt_cmp_data(rdata, 0);
	
	reset();
	mst_wr(TDR0_ADDR, 32'haaaa_aaaa, STRB_FULL);
	mst_wr(TDR1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR , 32'h0000_0001, STRB_FULL);
	wait_cycles(14);
	cnt_mst_rd(TDR0_ADDR,rdata);
        cnt_cmp_data(rdata, 32'haaaa_aab9);
        cnt_mst_rd(TDR1_ADDR,rdata);
        cnt_cmp_data(rdata, 32'h0000_0000);

	reset();
	mst_wr(TDR0_ADDR, 32'h5555_5555, STRB_FULL);
	mst_wr(TDR1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR , 32'h0000_0001, STRB_FULL);
	wait_cycles(4);
	cnt_mst_rd(TDR0_ADDR,rdata);
        cnt_cmp_data(rdata, 32'h5555_555a);
        cnt_mst_rd(TDR1_ADDR,rdata);
        cnt_cmp_data(rdata, 32'h0000_0000);

	$display("======================================");	
  	$display("====== Counter check timer_en H->L ===");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR , 32'h01, STRB_FULL);
	wait_cycles(20);
	mst_wr(TCR_ADDR , 32'h00, STRB_FULL);
	cnt_mst_rd(TDR0_ADDR,rdata);
        cnt_cmp_data(rdata, 0);
        cnt_mst_rd(TDR1_ADDR,rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter check timer_en L->H ===");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR , 32'h01, STRB_FULL);
	wait_cycles(20);
	mst_wr(TCR_ADDR , 32'h00, STRB_FULL);
	wait_cycles(10);
	mst_wr(TCR_ADDR , 32'h01, STRB_FULL);
	wait_cycles(4);
	cnt_mst_rd(TDR0_ADDR,rdata);
        cnt_cmp_data(rdata, 5);
        cnt_mst_rd(TDR1_ADDR,rdata);
        cnt_cmp_data(rdata, 0);


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask

