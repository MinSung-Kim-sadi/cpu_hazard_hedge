module Forwarding(
    input       [4:0]   Rs_ID,          // ID 단계 명령어의 첫 번째 소스 레지스터
                        Rt_ID,          // ID 단계 명령어의 두 번째 소스 레지스터
                        Rs_EX,          // EX 단계 명령어의 첫 번째 소스 레지스터
                        Rt_EX,          // EX 단계 명령어의 두 번째 소스 레지스터
                        Dst_MEM,        // MEM 단계 명령어의 목적지 레지스터
                        Dst_WB,         // WB 단계 명령어의 목적지 레지스터
    input               RegWrite_MEM,   // MEM 단계 명령어가 레지스터 쓰기 수행 여부
                        RegWrite_WB,    // WB 단계 명령어가 레지스터 쓰기 수행 여부
    output reg  [1:0]   ForwardA,       // EX 단계 첫 번째 오퍼랜드 포워딩 제어 신호
                        ForwardB,       // EX 단계 두 번째 오퍼랜드 포워딩 제어 신호
                        Forward1,       // ID 단계 첫 번째 오퍼랜드 포워딩 신호 (거의 사용 안 함)
                        Forward2        // ID 단계 두 번째 오퍼랜드 포워딩 신호 (거의 사용 안 함)
);

    // 초기값 설정
    initial begin
        ForwardA = 2'b00; // 기본값: 포워딩 없음
        ForwardB = 2'b00;
        Forward1 = 1'b0;
        Forward2 = 1'b0;
    end


    always @(*) begin
        // EX 단계 첫 번째 소스(Rs_EX) 포워딩 결정
        if (RegWrite_MEM && Dst_MEM && Dst_MEM == Rs_EX)
            ForwardA = 2'b10;   // MEM 단계 결과를 포워딩
        else if (RegWrite_WB && Dst_WB && Dst_WB == Rs_EX)
            ForwardA = 2'b01;   // WB 단계 결과를 포워딩
        else
            ForwardA = 2'b00;   // 포워딩 없음

        // EX 단계 두 번째 소스(Rt_EX) 포워딩 결정
        if (RegWrite_MEM && Dst_MEM && Dst_MEM == Rt_EX)
            ForwardB = 2'b10;   // MEM 단계 결과를 포워딩
        else if (RegWrite_WB && Dst_WB && Dst_WB == Rt_EX)
            ForwardB = 2'b01;   // WB 단계 결과를 포워딩
        else
            ForwardB = 2'b00;   // 포워딩 없음

        // ID 단계 포워딩 (거의 사용되지 않음, 단순 감지용)
        if (RegWrite_MEM && Dst_MEM && Dst_MEM == Rs_ID)
            Forward1 = 1'b1;    // Rs_ID 포워딩 필요 감지
        else
            Forward1 = 1'b0;

        if (RegWrite_MEM && Dst_MEM && Dst_MEM == Rt_ID)
            Forward2 = 1'b1;    // Rt_ID 포워딩 필요 감지
        else
            Forward2 = 1'b0;
    end

endmodule