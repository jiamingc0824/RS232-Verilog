`timescale 1ns / 1ps

module RS232Txd(
    input Reset,
    input Clock16x,
    input Send,
    input [7:0] DataIn,
    output Txd
    );


parameter stIdle = 2'b00, stData = 2'b01, stStop = 2'b11;
    
reg [1:0] presState, nextState;
reg iReset, iSend, iEnableTxdBuffer, iEnableShift, iClock1xEnable, iClock1x;
reg [8:0] iTxdBuffer = 9'b11111111;
reg [3:0] iClockDiv       = 4'b1010;
reg [3:0] iNoBitsSent = 4'b0000;
    
always@(posedge Clock16x)
begin
    if (Reset == 1'b1 || iReset == 1'b1) begin
        iClock1x       <= 1'b0;
        iClock1xEnable <= 1'b0;
        iClockDiv      <= 4'b1010;
    end else begin
        iSend <= Send;
    end

    if (Send == 1'b0 && iSend == 1'b1 && iClock1xEnable == 1'b0) 
        iClock1xEnable <= 1'b1;

    if (iClock1xEnable == 1'b1) begin
        iClockDiv <= iClockDiv + 1'b1;
        iClock1x <= iClockDiv[3];
    end
end

always@(iClock1x or iClock1xEnable)
begin
    if (iClock1xEnable == 1'b0) begin
        iNoBitsSent <= 4'h0;
        presState <= stIdle;
    end else if(iClock1x == 1'b1) begin
        presState <= nextState;
        if (iEnableTxdBuffer == 1'b1) begin
            iTxdBuffer <= {DataIn, 1'b0};      
        end
        if (iEnableShift == 1'b1) begin
            iNoBitsSent <= iNoBitsSent + 1'b1;
            iTxdBuffer <= {1'b1, iTxdBuffer[8:1]};
        end
    end
end

assign Txd = iTxdBuffer[0];

always@(presState, iClock1xEnable, iNoBitsSent)
begin
    iReset <= 1'b0;
    iEnableTxdBuffer <= 1'b0;
    iEnableShift <= 1'b0;
    case (presState)
        stIdle : begin
            if(iClock1xEnable == 1'b1) begin
                nextState <= stData;
                iEnableTxdBuffer <= 1'b1;
            end else
                nextState <= stIdle;
        end 
        stData : begin
            if(iNoBitsSent == 4'b1001) begin
                nextState <= stStop;
            end else begin
                iEnableShift <= 1'b1;
                nextState <= stData;
            end
        end
        stStop : begin
            nextState <= stIdle;
            iReset <= 1'b1;
        end
    endcase
end
endmodule
