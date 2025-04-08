------------------------------------------------------------------------
-- BOOSTER QUIZ 5-8-1
------------------------------------------------------------------------

문제)
'2025년 1월' 주문에 대해 주문 건수와 주문이 존재하는 매장 건수를 구하세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ ord_dtm이 2025년 1월인 데이터
  ㅁ 조회 항목: ord_cnt, ord_shop_cnt
    ㅇ ord_cnt: 주문 건수
    ㅇ ord_shop_cnt: 주문이 존재하는 매장 건수
  
결과)
    ord_cnt  ord_shop_cnt  
    -------  ------------  
    14290    289           
    
답안)
SELECT COUNT(*) ord_cnt, COUNT(DISTINCT shop_id) ord_shop_cnt
FROM startdbmy.tr_ord
WHERE ord_dtm >= STR_TO_DATE('20250101','%Y%m%d')
AND ord_dtm < STR_TO_DATE('20250201','%Y%m%d');
      
  
 
  
------------------------------------------------------------------------
-- BOOSTER QUIZ 5-9-1
------------------------------------------------------------------------
문제) 아래 SQL로 얻은 결과 집합의 식별자를 말하세요.

    SELECT  t1.mbr_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd
            ,COUNT(*) ord_cnt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20231101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20231201','%Y%m%d')
    AND     t1.ord_amt >= 20000
    GROUP BY t1.mbr_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
    ORDER BY t1.mbr_id ,ord_ymd;


답안)
-- mbr_id, order_ymd 이다.
-- GROUP BY 절에 있는 mbr_id, order_ymd의 조합으로 생성된 테이블의 행을 식별할 수 있다.


------------------------------------------------------------------------
-- BOOSTER QUIZ 5-9-2
------------------------------------------------------------------------
문제) 아래 SQL로 얻은 결과 집합의 식별자를 말하세요.

    SELECT  t1.shop_id ,DATE_FORMAT(t1.ord_dtm,'%H') ord_hour ,t1.ord_st
            ,SUM(t1.ord_amt) Ord_amt_sum
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20231224','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20231225','%Y%m%d')
    AND     t1.ord_amt >= 20000
    GROUP BY t1.shop_id ,DATE_FORMAT(t1.ord_dtm,'%H') ,t1.ord_st;


답안)
-- shop_id, ord_hour, ord_st이다. 
-- GROUP BY 절에 있는 shop_id, ord_hour, ord_st의 조합으로 생성된 테이블의 행을 식별할 수 있다.