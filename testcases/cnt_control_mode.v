task run_test();
    begin
	$display("======================================");	
  	$display("====== Counter speed is not divided ==");
  	$display("======================================");
	mst_wr(TCR_ADDR, 32'h0000_0003, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 256);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("======================================");	
  	$display("====== Counter speed is divided by 2 =");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0103, STRB_FULL);
	wait_cycles(255);
	#1;
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 128);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is divided by 4 =");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0203, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 64);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is divided by 8 =");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0303, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 32);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is divided by 16=");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0403, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 16);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is divided by 32=");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0503, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 8);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is divided by 64=");
  	$display("======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0603, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 4);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("=======================================");	
  	$display("====== Counter speed is divided by 128=");
  	$display("=======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0703, STRB_FULL);
	wait_cycles(1027);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 8);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("=======================================");	
  	$display("====== Counter speed is divided by 256=");
  	$display("=======================================");
	reset();
	mst_wr(TCR_ADDR, 32'h0000_0803, STRB_FULL);
	wait_cycles(1027);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 4);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("====== Counter speed is not divided ==");
  	$display("======================================");
	mst_wr(TCR_ADDR, 32'h0000_0003, STRB_FULL);
	wait_cycles(255);
	cnt_mst_rd(TDR0_ADDR, rd


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask

