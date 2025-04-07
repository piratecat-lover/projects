------------------------------------------------------------------------
-- BOOSTER QUIZ 5-1-1
------------------------------------------------------------------------
문제)
    (SQL-1)과 (결과-1)을 참고해 아래 질문에 답하세요.
      > (SQL-2)와 (SQL-3)은 (SQL-1)을 GROUP BY 한 SQL입니다.
      > (SQL-2)를 실행하지 않고 (결과-2)를 채우세요.
      > (SQL-3)을 실행하지 않고 (결과-3)을 채우세요.

결과)
    -- (SQL-1)
    SELECT  t1.ord_no, t1.ord_dtm ,t1.shop_id ,t1.ord_st
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_no IN (730305, 730306, 730307, 730308, 730310, 730318, 730319)
    ORDER BY t1.ord_no DESC;


    -- (결과-1)
    ord_no  ord_dtm              shop_id  ord_st  
    ------  -------------------  -------  ------  
    730319  2025-01-25 08:16:00  S100     PREP    
    730318  2025-01-25 08:14:00  S100     PREP    
    730310  2025-01-25 08:00:00  S280     MFGC    
    730308  2025-01-25 07:58:00  S100     MFGC    
    730307  2025-01-25 07:57:00  S280     PKUP    
    730306  2025-01-25 07:56:00  S280     PKUP    
    730305  2025-01-25 07:56:00  S100     PKUP    


    -- (SQL-2)
    SELECT  t1.ord_st
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_no IN (730305, 730306, 730307, 730308, 730310, 730318, 730319)
    GROUP BY t1.ord_st
    ORDER BY t1.ord_st ASC;


    -- (SQL-3)
    SELECT  t1.shop_id
    FROM    startdbmy.tr_ord t1
    WHERE t1.ord_no IN (730305, 730306, 730307, 730308, 730310, 730318, 730319)
    GROUP BY t1.shop_id
    ORDER BY t1.shop_id ASC;

답안)


    -- (결과-2)
ord_st
------
MFGC
PKUP
PREP


    -- (결과-3)
shop_id
-------
S100
S280



------------------------------------------------------------------------
-- BOOSTER QUIZ 5-2-1
------------------------------------------------------------------------
문제)
    (SQL-1)과 (결과-1)을 참고해 아래 질문에 답하세요.
      > (SQL-2)는 (SQL-1)을 GROUP BY 한 SQL입니다.
      > (SQL-2)를 실행하지 않고 (결과-2)를 채우세요.

결과)

    -- (SQL-1)
    SELECT  t1.shop_id, t1.mbr_id ,t1.ord_dtm ,t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20200301','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20200401','%Y%m%d')
    AND     t1.shop_id IN ('S047','S064','S068')
    ORDER BY t1.shop_id ,t1.ord_no;

    -- (결과-1)
    shop_id  mbr_id  ord_dtm              ord_amt    
    -------  ------  -------------------  ---------  
    S047     M0346   2020-03-05 07:02:00  4000.000   
    S047     M0946   2020-03-07 07:02:00  4500.000   
    S047     M0046   2020-03-11 07:02:00  4000.000   
    S047     M1246   2020-03-16 07:01:00  8000.000   
    S064     M1263   2020-03-06 06:31:00  4000.000   
    S068     M1267   2020-03-01 06:32:00  4000.000   
    S068     M1267   2020-03-31 06:32:00  14000.000  

    -- (SQL-2)
    SELECT  t1.shop_id ,COUNT(*) CNT, SUM(t1.ord_amt) SUM_AMT
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20200301','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20200401','%Y%m%d')
    AND     t1.shop_id IN ('S047','S064','S068')
    GROUP BY t1.shop_id
    ORDER BY t1.shop_id;


    
답안)

    -- (결과-2)
shop_id  CNT  SUM_AMT
--------  ---  ---------
S047      4   20500.000
S064      1   4000.000
S068      2   18000.000


    

------------------------------------------------------------------------
-- BOOSTER QUIZ 5-2-2
------------------------------------------------------------------------
문제)
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_cat가 COF(커피)인 데이터
  ㅁ 조회 항목: item_size_cd, item_cnt
    ㅇ item_cnt: item_size_cd별 상품 건수
  ㅁ 추가 고려 사항
    ㅇ item_size_cd별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: item_size_cd로 오름차순 정렬하세요.


결과)
    item_size_cd  item_cnt  
    ------------  --------  
    BIG           4         
    REG           8          

답안)
SELECT item_size_cd, COUNT(*) item_cnt
FROM ms_item
WHERE item_cat = 'COF'
GROUP BY item_size_cd
ORDER BY item_size_cd;






------------------------------------------------------------------------
-- BOOSTER QUIZ 5-2-3
------------------------------------------------------------------------
문제)
2022년 1월 5일 주문에 대해 회원ID별로 주문금액 합계와 주문 건수를 뽑아주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2022년 1월 5일인 주문 데이터
  ㅁ 조회 항목: mbr_id, ord_amt_sum, ord_cnt
    ㅇ ord_amt_sum: mbr_id별 ord_amt의 합계
    ㅇ ord_cnt: mbr_id별 데이터 건수
  ㅁ 추가 고려 사항
    ㅇ mbr_id별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: ord_amt_sum으로 내림차순 정렬하세요.


결과)
    mbr_id  ord_amt_sum  ord_cnt  
    ------  -----------  -------  
    M0887   41500.000    4        
    M0108   38000.000    3        
    M0932   32000.000    4        
    M0918   31000.000    4        
    M0933   31000.000    4  
          -- (생략) --

답안)
SELECT mbr_id, SUM(ord_amt) ord_amt_sum, COUNT(*) ord_cnt
FROM tr_ord
WHERE ord_dtm >= STR_TO_DATE('20220105','%Y%m%d') AND ord_dtm < STR_TO_DATE('20220106','%Y%m%d')
GROUP BY mbr_id
ORDER BY ord_amt_sum DESC;



------------------------------------------------------------------------
-- BOOSTER QUIZ 5-3-1
------------------------------------------------------------------------
문제)
    아래 SQL에서 잘 못 처리된 부분을 고르고, 왜 잘못되었는지 설명하세요.
        
    SELECT  t1.hot_cold_cd         -- 1
            ,t1.lach_dt            -- 2
    FROM    startdbmy.ms_item t1
    WHERE   t1.item_cat = 'BEV'    -- 3
    GROUP BY t1.hot_cold_cd;       -- 4

답안)
-- (1) 2: GROUP BY에 포함되지 않은 컬럼을 집계 함수 없이 SELECT절에 사용하고 있다.
-- 해결: t1.lach_dt를 GROUP BY에 추가하거나, MIN(t1.lach_dt)와 같이 집계 함수로 처리해야 한다.
-- 집계함수를 사용할 경우 t1.lach_dt는 DATETIME 형식이므로 SUM, AVG보다 COUNT나 MIN, MAX 등의 집계함수가 적합하다.
-- GROUP BY에 포함할 경우 다음과 같이 실행한다.
SELECT t1.hot_cold_cd, t1.lach_dt
FROM ms_item t1
WHERE t1.item_cat = 'BEV'
GROUP BY t1.hot_cold_cd, t1.lach_dt;


------------------------------------------------------------------------
-- BOOSTER QUIZ 5-3-2
------------------------------------------------------------------------
문제)
    아래 SQL이 실행될 수 있도록 GROUP BY에 필요한 컬럼을 적으세요.
    
    SELECT  MIN(t1.ord_dtm) first_ord_dtm
            ,MAX(t1.ord_dtm) last_ord_dtm
            ,t1.mbr_id
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20220101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20220103','%Y%m%d')
    AND     t1.shop_id IN ('S012','S212')
    GROUP BY ?;

답안)
-- SELECT 구문에서 유일하게 집계함수로 포함되지 않은 mbr_id를 GROUP BY에 추가해야 한다.
GROUP BY t1.mbr_id;





