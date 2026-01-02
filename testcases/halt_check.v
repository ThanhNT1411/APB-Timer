task run_test();
    begin
	$display("======================================");	
  	$display("====== halt_ack is accert ============");
  	$display("======================================");
	reset();
	dbg_mode=1;
	mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	cnt_mst_rd(THCSR_ADDR, rdata);
        cnt_cmp_data(rdata[1], 1);

	$display("======================================");	
  	$display("====== halt_ack is not accert ========");
  	$display("======================================");	
	reset();
	dbg_mode = 0;
	mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	cnt_mst_rd(THCSR_ADDR, rdata);
        cnt_cmp_data(rdata[1], 0);

	reset();
	dbg_mode = 1;
	mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	cnt_mst_rd(THCSR_ADDR, rdata);
        cnt_cmp_data(rdata[1], 0);

	$display("======================================");	
  	$display("= Halt mode: Counter in default mode =");
  	$display("======================================");	
	$display("Counter stop count in halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 23);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("Counter continue count after exit halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	wait_cycles(5);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 29);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("= Halt mode: Counter in control mode =");
  	$display("= Counter speed is not divided       =");
  	$display("======================================");	
	$display("Counter stop count in halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0003, STRB_FULL);
	wait_cycles(20);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 23);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("Counter continue count after exit halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0003, STRB_FULL);
	wait_cycles(20);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	wait_cycles(5);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 29);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("= Halt mode: Counter in control mode =");
  	$display("= Counter speed is divided by 2      =");
  	$display("======================================");	
	$display("Counter stop count in halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0103, STRB_FULL);
	wait_cycles(21);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 12);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("Counter continue count after exit halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0103, STRB_FULL);
	wait_cycles(20);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	wait_cycles(6);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 15);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("======================================");	
  	$display("= Halt mode: Counter in control mode =");
  	$display("= Counter speed is divided by 32     =");
  	$display("======================================");	
	$display("Counter stop count in halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0503, STRB_FULL);
	wait_cycles(28);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(10);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("Counter continue count after exit halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0503, STRB_FULL);
	wait_cycles(28);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(30);
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 1);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("= Halt mode: Counter in control mode =");
  	$display("= Counter speed is divided by 256    =");
  	$display("======================================");	
	$display("Counter stop count in halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0803, STRB_FULL);
	wait_cycles(200);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(100);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);
	
	$display("Counter continue count after exit halt mode");	
	reset();
	mst_wr(TCR_ADDR  , 32'h0000_0803, STRB_FULL);
	wait_cycles(200);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(100);
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0000, STRB_FULL);
	wait_cycles(52);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 1);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);

	$display("======================================");	
  	$display("= Halt enable whern interrupt ========");
  	$display("======================================");	
	reset();
	mst_wr(TCMP0_ADDR, 32'h0000_0014, STRB_FULL);
	mst_wr(TCMP1_ADDR, 32'h0000_0000, STRB_FULL);
	mst_wr(TCR_ADDR  , 32'h0000_0001, STRB_FULL);
	wait_cycles(17);
	dbg_mode = 1;
	cnt_mst_wr(THCSR_ADDR, 32'h0000_0001, STRB_FULL);
	wait_cycles(20);
	cnt_mst_rd(TISR_ADDR, rdata);
        cnt_cmp_data(rdata, 1);
	cnt_mst_rd(TDR0_ADDR, rdata);
        cnt_cmp_data(rdata, 20);
        cnt_mst_rd(TDR1_ADDR, rdata);
        cnt_cmp_data(rdata, 0);


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    end
endtask

