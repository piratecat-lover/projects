
    

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-2-1
------------------------------------------------------------------------

문제)
(SQL-1)과 (결과-1)을 참고해, (SQL-2)를 실행하면 나올 (결과-2)를 채우세요.
  ㅁ (SQL-2)는 (SQL-1)에 분석함수만 추가한 SQL입니다.
  ㅁ SQL을 실행하지 않고 (결과-2)를 예측해서 채우세요.


결과)
    -- (SQL-1)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S261'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20211001','%Y%m%d')
    ORDER BY t1.ord_dtm DESC;

    -- (결과-1)
    ord_no  shop_id  ord_dtm              ord_amt   
    ------  -------  -------------------  --------  
    127776  S261     2021-09-22 06:46:00  8500.000  
    127767  S261     2021-09-22 06:39:00  4000.000  
    127764  S261     2021-09-22 06:38:00  4000.000  
    127751  S261     2021-09-22 06:31:00  4000.000  
    123551  S261     2021-09-01 06:32:00  4000.000  


    -- (SQL-2)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
            ,RANK() OVER(ORDER BY t1.ord_dtm ASC) ord_dtm_rank_ov
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S261'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20211001','%Y%m%d')
    ORDER BY t1.ord_dtm DESC;

    -- (결과-2)
    ord_no  shop_id  ord_dtm              ord_amt   ord_dtm_rank_ov  
    ------  -------  -------------------  --------  ---------------  
    127776  S261     2021-09-22 06:46:00  8500.000  (             ) 
    127767  S261     2021-09-22 06:39:00  4000.000  (             ) 
    127764  S261     2021-09-22 06:38:00  4000.000  (             ) 
    127751  S261     2021-09-22 06:31:00  4000.000  (             ) 
    123551  S261     2021-09-01 06:32:00  4000.000  (             ) 

답안)
ord_no  shop_id  ord_dtm              ord_amt   ord_dtm_rank_ov  
------  -------  -------------------  --------  ---------------  
127776  S261     2021-09-22 06:46:00  8500.000  (      5      ) 
127767  S261     2021-09-22 06:39:00  4000.000  (      4      ) 
127764  S261     2021-09-22 06:38:00  4000.000  (      3      ) 
127751  S261     2021-09-22 06:31:00  4000.000  (      2      ) 
123551  S261     2021-09-01 06:32:00  4000.000  (      1      ) 



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-2-2
------------------------------------------------------------------------
문제)
회원 등급이 플래티넘, 가입유형이 초대, 가입일시가 2022년 4월인 회원을 가입일시에 따라 순위를 구해서 보여주세요.
  ㅁ 대상 테이블: ms_mbr
  ㅁ 조회 조건: mbr_gd가 PLAT이면서, join_tp가 INV(초대), join_dtm이 2022년 4월
  ㅁ 조회 항목: mbr_id, nick_nm, join_dtm, mbr_gd, join_dtm_rank_ov
  ㅁ 추가 고려 사항:
    ㅇ join_dtm_rank_ov는 join_dtm에 따른 순번입니다.
      - RANK 분석함수로 처리하세요.
      - join_dtm이 빠르면 1위가 됩니다.
    

결과)
    mbr_id  nick_nm     join_dtm             mbr_gd  join_dtm_rank_ov  
    ------  ----------  -------------------  ------  ----------------  
    M3196   Sweet63     2022-04-21 00:00:00  PLAT    1                 
    M3226   Moon64      2022-04-26 00:00:00  PLAT    2                 
    M3027   Mountain60  2022-04-27 00:00:00  PLAT    3                 
    M3097   Swift61     2022-04-27 00:00:00  PLAT    3                 
    M3507   Cosmos70    2022-04-27 00:00:00  PLAT    3                 
    M3866   Galaxy77    2022-04-28 00:00:00  PLAT    6                 
    M3377   Mountain67  2022-04-30 00:00:00  PLAT    7                 
    M3417   Gold68      2022-04-30 00:00:00  PLAT    7                 
    M3646   Sweet72     2022-04-30 00:00:00  PLAT    7                 
    M3786   Shadow75    2022-04-30 00:00:00  PLAT    7                 
    M3856   Copper77    2022-04-30 00:00:00  PLAT    7                 
    M4347   Swift86     2022-04-30 00:00:00  PLAT    7                 

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.join_dtm, t1.mbr_gd, RANK() OVER (ORDER BY t1.join_dtm) join_dtm_rank_ov
FROM startdbmy.ms_mbr t1
WHERE t1.mbr_gd = 'PLAT'
AND t1.join_tp = 'INV'
AND t1.join_dtm >= STR_TO_DATE('20220401','%Y%m%d')
AND t1.join_dtm < STR_TO_DATE('20220501','%Y%m%d')
ORDER BY t1.join_dtm;


