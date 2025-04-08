------------------------------------------------------------------------
-- BOOSTER QUIZ 5-4-1
------------------------------------------------------------------------
문제)
    아래는 에러가 발생하는 SQL입니다. item_cat(상품카테고리)별 GROUP BY를 유지할 경우, 아래 SQL에서 잘못된 부분 두 곳을 찾으세요.
    
    SELECT  t1.item_cat                -- 1
            ,COUNT(*) ItemCnt          -- 2
            ,t1.item_size_cd           -- 3
    FROM    startdbmy.ms_item t1
    WHERE   t1.hot_cold_cd = 'HOT'
    GROUP BY t1.item_cat               -- 4
    HAVING COUNT(*) >= 2               -- 5
           AND
           t1.item_id NOT LIKE 'A%'    -- 6

답안)
-- 3번. t1.item_size_cd는 GROUP BY에 포함되지도, 집계함수로 처리되지도 않았다.
-- 6번. HAVING절은 GROUP BY절에서 집계된 결과에 대해 조건을 걸어야 한다. 따라서 t1.item_id는 WHERE절에서 조건을 걸어야 한다.


    

------------------------------------------------------------------------
-- BOOSTER QUIZ 5-4-2
------------------------------------------------------------------------
문제)
2024년 1월 동안 주문금액 합계가 40만원 이상인 회원 리스트를 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2024년 1월인 주문 데이터
  ㅁ 조회 항목: mbr_id, ord_amt_sum
    ㅇ ord_amt_sum: mbr_id별 ord_amt의 합계
  ㅁ 추가 고려 사항:
    ㅇ mbr_id별로 GROUP BY 처리하세요.
    ㅇ ord_amt_sum이 40만원 이상인 회원만 조회해주세요.
  ㅁ 정렬 기준: ord_amt_sum로 내림차순 정렬해주세요.
        
결과)
    mbr_id  sum_ord_amt  
    ------  -----------  
    M0025   417800.000   
    M0031   409600.000   
    M0021   407500.000   
    M0006   407200.000   
    M0020   402100.000   


답안)
SELECT mbr_id, SUM(ord_amt) ord_amt_sum
FROM startdbmy.tr_ord
WHERE ord_dtm >= STR_TO_DATE('20240101','%Y%m%d')
AND ord_dtm < STR_TO_DATE('20240201','%Y%m%d')
GROUP BY mbr_id
HAVING SUM(ord_amt) >= 400000
ORDER BY ord_amt_sum DESC;



------------------------------------------------------------------------
-- BOOSTER QUIZ 5-5-1
------------------------------------------------------------------------

문제)
    (SQL-1)과 (결과-1)을 참고해, (SQL-2)를 실행하면 나올 (결과-2)를 채우세요.
      > (SQL-2)를 실행하지 않고 (결과-2)를 예측해서 채우세요.
      > (SQL-2)는 (SQL-1)을 GROUP BY 처리한 SQL입니다.
      

    -- (SQL-1)
    SELECT  t1.ord_no ,t1.ord_dtm ,t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S207'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20211201','%Y%m%d')
    ORDER BY t1.ord_no ASC;

    -- (결과-1)
    ord_no  ord_dtm              ord_amt   
    ------  -------------------  --------  
    125069  2021-09-06 07:01:00  4500.000  
    125127  2021-09-06 07:06:00  4000.000  
    128416  2021-09-25 07:02:00  8000.000  
    134239  2021-10-26 07:01:00  4000.000  
    134297  2021-10-26 07:06:00  9000.000  
    139163  2021-11-16 07:01:00  4000.000  
    139221  2021-11-16 07:06:00  4500.000  


    -- (SQL-2)
    SELECT  DATE_FORMAT(t1.ord_dtm,'%Y%m') ord_ym ,COUNT(*) cnt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S207'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20211201','%Y%m%d')
    GROUP BY DATE_FORMAT(t1.ord_dtm,'%Y%m')
    ORDER BY ord_ym ASC;


답안)
-- 2021년 9월, 10월, 11월에 각각 3건, 2건, 2건의 주문이 발생했다.
ord_ym    cnt
------  -------
202109     3
202110     2
202111     2



------------------------------------------------------------------------
-- BOOSTER QUIZ 5-5-2
------------------------------------------------------------------------

문제)
'S246' 매장의 2022년 주문 데이터에 대해 주문년월별 주문 건수와 주문금액 합계를 구해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: shop_id가 S246이면서 ord_dtm이 2022년인 주문 데이터
  ㅁ 조회 항목: ord_ym, ord_cnt, ord_amt_sum
    ㅇ ord_ym: ord_dtm을 년월(%Y%m) 형태의 문자로 변형한 항목입니다.
    ㅇ ord_cnt: ord_ym별 데이터 건수
    ㅇ ord_amt_sum: ord_ym별 ord_amt를 SUM 집계한 값
  ㅁ 추가 고려 사항:
    ㅇ ord_ym별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: ord_ym으로 내림차순 정렬하세요.
        
결과)
    ord_ym  ord_cnt  ord_amt_sum  
    ------  -------  -----------  
    202212  25       185000.000   
    202211  25       184000.000   
    202210  25       162500.000   
    202209  25       144000.000   
    202208  27       229500.000   
    202207  22       164500.000   
    202206  14       88500.000    
    202205  2        8500.000     
    202204  2        8500.000     
    202203  2        11500.000    
    202202  2        13000.000    
    202201  2        24000.000    

답안)
SELECT DATE_FORMAT(ord_dtm,'%Y%m') ord_ym, COUNT(*) ord_cnt, SUM(ord_amt) ord_amt_sum
FROM startdbmy.tr_ord
WHERE shop_id = 'S246' AND ord_dtm >= STR_TO_DATE('20220101','%Y%m%d') AND ord_dtm < STR_TO_DATE('20230101','%Y%m%d')
GROUP BY DATE_FORMAT(ord_dtm, '%Y%m')
ORDER BY ord_ym DESC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 5-5-3
------------------------------------------------------------------------

문제)
‘2022년’ 주문에 대해, 주문 시간대별로 주문 건수를 보여주세요. 주문 건수가 가장 많은 시간대부터 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2022년인 주문 데이터
  ㅁ 조회 항목: ord_hour, ord_cnt
    ㅇ ord_hour: ord_dtm에서 DATE_FORMAT을 사용해 시간(%H)만 추출한 항목
    ㅇ ord_cnt: ord_hour별 주문 건수
  ㅁ 추가 고려 사항
    ㅇ ord_hour별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: ord_cnt로 내림차순 정렬하세요.


결과)
    ord_hour  ord_cnt  
    --------  -------  
    07        111162   
    06        26677    
    08        6149     
    09        2573     
    10        1116     
    11        736      
    12        184      
    13        145       

답안)
SELECT DATE_FORMAT(ord_dtm,'%H') ord_hour, COUNT(*) ord_cnt
FROM startdbmy.tr_ord
WHERE ord_dtm >= STR_TO_DATE('20220101','%Y%m%d') AND ord_dtm < STR_TO_DATE('20230101','%Y%m%d')
GROUP BY DATE_FORMAT(ord_dtm, '%H')
ORDER BY ord_cnt DESC;



------------------------------------------------------------------------
-- BOOSTER QUIZ 5-6-1
------------------------------------------------------------------------

문제)
‘S002’와 ‘S003’ 매장의 ‘2023년 6월 1일’부터 ‘2023년 6월 3일’까지의 주문 데이터에 대해, 매장ID와 주문일자별로 주문 건수를 집계해 주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ shop_id가 S002이거나 S003이면서,
    ㅇ ord_dtm이 2023년 6월 1일 이상, 2023년 6월 3일 이하(2023년 6월 4일 미만)인 데이터
  ㅁ 조회 항목: shop_id, ord_ymd(주문일자), ord_cnt
    ㅇ ord_ymd: ord_dtm을 DATE_FORMAT을 사용해 %Y%m%d(년월일) 형태의 문자열로 변환한 항목
    ㅇ ord_cnt: shop_id, ord_ymd별 주문 건수
  ㅁ 추가 고려 사항: shop_id, ord_ymd별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: shop_id로 오름차순 한 후에 ord_ymd로 오름차순 하세요.



결과)
    shop_id  ord_ymd   ord_cnt  
    -------  --------  -------  
    S002     20230601  2        
    S002     20230602  6        
    S002     20230603  4        
    S003     20230601  16       
    S003     20230602  9        
    S003     20230603  4        

답안)
SELECT shop_id, DATE_FORMAT(ord_dtm,'%Y%m%d') ord_ymd, COUNT(*) ord_cnt
FROM startdbmy.tr_ord
WHERE shop_id in ('S002', 'S003') AND ord_dtm >= STR_TO_DATE('20230601','%Y%m%d') AND ord_dtm < STR_TO_DATE('20230604','%Y%m%d')
GROUP BY shop_id, DATE_FORMAT(ord_dtm, '%Y%m%d')
ORDER BY shop_id ASC, ord_ymd ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 5-6-2
------------------------------------------------------------------------

문제)
‘S213’과 ‘S214 ‘매장의 '2022년 1월' 주문에 대해, 매장ID, 제조완료분수별로 카운트해 주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ shop_id가 ‘S213’이거나 ‘S214’ 이면서,
    ㅇ ord_dtm이 2022년 1월인 데이터.
  ㅁ 조회 항목: shop_id, 제조완료분수, ord_cnt
    ㅇ 제조완료분수: ord_dtm(주문일시)부터 prep_cmp_dtm(준비완료일시)까지 걸린 분(MINUTE)수
    ㅇ ord_cnt: shop_id, 제조완료분수별 데이터 건수
  ㅁ 추가 고려 사항: shop_id, 제조완료분수별로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: shop_id로 오름차순 한 후에 제조완료분수로 오름차순 하세요.
  
  
결과)
    shop_id  제조완료분수  ord_cnt  
    -------  ------------  -------  
    S213     1             2        
    S213     4             1        
    S214     1             1        
    S214     2             1        
    S214     3             1        

답안)
SELECT shop_id, TIMESTAMPDIFF(MINUTE, ord_dtm, prep_cmp_dtm) 제조완료분수, COUNT(*) ord_cnt
FROM startdbmy.tr_ord
WHERE shop_id in ('S213', 'S214') AND ord_dtm >= STR_TO_DATE('20220101','%Y%m%d') AND ord_dtm < STR_TO_DATE('20220201','%Y%m%d')
GROUP BY shop_id, TIMESTAMPDIFF(MINUTE, ord_dtm, prep_cmp_dtm)
ORDER BY shop_id ASC, 제조완료분수 ASC;