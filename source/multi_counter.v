
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/07 16:40:15
// Design Name: 
// Module Name: multi_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: multi_counter is used to manage the exu_ready signal.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module multi_counter(

    input  [`MAX_DELAY_WIDTH-1:0]     mc_i_pc_cycle  ,
    input                             mc_i_ifu_valid ,
    output                            mc_o_delay_err , 
    output                            mc_o_exu_ready ,

    input                             memtop_enable  ,
    input                             memtop_ready   ,
 
    input                             clk            ,
    input                             rst_n          ,

    // test port
    output [`MAX_DELAY_WIDTH-1:0]     count_t
    );

    // Internal signals
    reg    [`MAX_DELAY_WIDTH-1:0]     count      ;
    reg    [1:0                 ]     curr_state ;
    

    // Build a counter.
    // Counter keeps counting which the nxt_state is not IDLE.
    // And it return to 0 when the nxt_state is IDLE.
    always@ (posedge clk or negedge rst_n) begin
        if ((~rst_n)|(memtop_enable)) begin: CLR
            count <= `MAX_DELAY_WIDTH'd1;
        end

        else begin
            if (~(count == mc_i_pc_cycle)) begin: COUNT_BUSY
                count <= count + `MAX_DELAY_WIDTH'd1;
            end
            else if ((count == mc_i_pc_cycle) & ~mc_i_ifu_valid) begin: WAIT
                count <= count;
            end
            else begin: RST4NXTIR
                count <= `MAX_DELAY_WIDTH'd1;
            end
        end
    end
    

    // The defination of each state.
    // 1. READY (00) : IR has been fully excuted. PC and IR is permitted to refresh.  
    // 2. BUSY  (01) : Current IR is still running.
    // 3. WAIT  (11) : Next IR is not valid yet. Waiting for IFU.
    wire integrated_ready = (count == mc_i_pc_cycle) | (memtop_enable & memtop_ready); // when the instr is ld or st, count will be locked at 1 and use external ready from memtop.
    always@(*) begin
        if (integrated_ready & ~mc_i_ifu_valid) begin: WAITING
            curr_state = 2'b11;
        end
        else if (~integrated_ready) begin: BUSY
            curr_state = 2'b01;
        end
        else begin: READY
            curr_state = 2'b00;
        end
    end

    // Logic output   
    assign mc_o_exu_ready = (curr_state == 2'b00)? 1'b1: 1'b0;                                               
    assign mc_o_delay_err = (mc_i_pc_cycle == `MAX_DELAY_WIDTH'd0 |                // i_cycle == 0 is forbiddened.
                             count         == `MAX_DELAY_WIDTH'd0 |                // count == 0 is forbiddened.
                             mc_i_pc_cycle < count                 )? 1'b1: 1'b0;  // count < pc_cycle is forbiddened.
    assign count_t        = count;

endmodule
