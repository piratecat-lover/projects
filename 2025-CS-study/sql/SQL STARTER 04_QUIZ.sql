------------------------------------------------------------------------
-- BOOSTER QUIZ 4-6-1
------------------------------------------------------------------------
문제)
    [Fig-4-6-1-a]의 ms_mbr 테이블의 ERD와 함께 실제 데이터를 조회해 보고 아래 질문들에 답하세요.
    
    > PK 컬럼은 무엇인가요?
    > 아래 컬럼들이 관리하는 데이터가 어떤 데이터인지 생각해 적어보세요.
      > mbr_id: 회원을 식별하는 ID값
      > nick_nm: 닉네임, 회원을 부르는 호칭
      > join_dtm:
      > join_tp:
      > mbr_gd:
      > mbr_st:
      > leave_dtm:

    
      
------------------------------------------------------------------------
-- BOOSTER QUIZ 4-6-2
------------------------------------------------------------------------
문제)
    DESC 명령어로 ms_mbr 테이블의 자료형을 살펴보고 컬럼별로 자료형을 채워 넣으세요.
    
    > mbr_id: VARCHAR
    > nick_nm:
    > join_dtm:
    > join_tp:
    > mbr_gd:
    > mbr_st:
    > leave_dtm:

    

------------------------------------------------------------------------
-- BOOSTER QUIZ 4-6-3
------------------------------------------------------------------------
문제)
    mbr_gd(회원등급), mbr_st(회원상태), join_tp(가입유형)에 대한 코드와 명칭을 cm_base_cd(기준코드) 테이블에서 확인하고 아래 내용을 정리하세요.

    > mbr_gd: GOLD(Gold), PLAT(Platinum), SILV(      )
    > mbr_st: ACTV(             ), INAC(               )
    > join_tp: DRCT(      ), INV(       ), SNS(                      )
    



------------------------------------------------------------------------
-- BOOSTER QUIZ 4-6-4
------------------------------------------------------------------------
문제)
    [Fig-4-6-2]를 통해 ms_mbr(회원) 테이블과 tr_ord(주문) 테이블을 살펴보고, ( A ), ( B ) 에 들어갈 내용을 채우세요.
    
    > ms_mbr 테이블의 PK인 (     A     ) 가 (    B    ) 테이블에도 있다.
    > 이는 어느 회원이 주문했는지가 (    B    ) 테이블에 관리되고 있다는 뜻이다.
      > ( A ):
      > ( B ):  

 

------------------------------------------------------------------------
-- BOOSTER QUIZ 4-6-5
------------------------------------------------------------------------
문제)
    현재 비활성화된 회원의 회원ID와 닉네임, 탈퇴일시를 보여주세요. 최근에 탈퇴한 회원일수록 먼저 조회되도록 처리해 주세요.
      > ms_mbr 테이블에 대한 이해를 바탕으로 SQL을 작성해 보기 바랍니다.

결과)
    mbr_id  nick_nm    leave_dtm            
    ------  ---------  -------------------  
    M8496   Sweet169   2023-11-17 00:00:00  
    M9496   Sweet189   2023-11-15 00:00:00  
    M9486   Shadow189  2023-11-12 00:00:00  
    M9476   Moon189    2023-11-07 00:00:00  
    ...생략...


