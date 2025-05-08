

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-5-1
------------------------------------------------------------------------
문제) (SQL-1)과 (결과-1)을 참고해, (SQL-2)를 실행하면 나올 (결과-2)를 채우세요.
  ㅁ SQL을 실행하지 않고 (결과-2)를 예측해서 채우세요.

결과)

    -- (SQL-1)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S092'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20210915','%Y%m%d')
    ORDER BY t1.ord_no ASC;


    -- (결과-1)
    ord_no  shop_id  ord_dtm              ord_amt    
    ------  -------  -------------------  ---------  
    124121  S092     2021-09-03 06:32:00  4500.000   
    124135  S092     2021-09-03 06:36:00  4000.000   
    125684  S092     2021-09-09 06:32:00  4000.000   
    125994  S092     2021-09-10 06:31:00  4500.000   
    126773  S092     2021-09-14 06:31:00  4500.000   
    126781  S092     2021-09-14 06:38:00  14000.000  

    -- (SQL-2)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
            ,LAG(t1.ord_amt) OVER(ORDER BY t1.ord_dtm ASC) ord_amt_bf
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S092'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20210915','%Y%m%d')
    ORDER BY t1.ord_no ASC;


    -- (결과-2)
    ord_no  shop_id  ord_dtm              ord_amt    ord_amt_bf  
    ------  -------  -------------------  ---------  -----------  
    124121  S092     2021-09-03 06:32:00  4500.000   (         )  
    124135  S092     2021-09-03 06:36:00  4000.000   (         )  
    125684  S092     2021-09-09 06:32:00  4000.000   (         )  
    125994  S092     2021-09-10 06:31:00  4500.000   (         )  
    126773  S092     2021-09-14 06:31:00  4500.000   (         )  
    126781  S092     2021-09-14 06:38:00  14000.000  (         )  



답안)
    ord_no  shop_id  ord_dtm              ord_amt    ord_amt_bf  
    ------  -------  -------------------  ---------  -----------  
    124121  S092     2021-09-03 06:32:00  4500.000   (   NULL   )  
    124135  S092     2021-09-03 06:36:00  4000.000   ( 4500.000 )  
    125684  S092     2021-09-09 06:32:00  4000.000   ( 4000.000 )  
    125994  S092     2021-09-10 06:31:00  4500.000   ( 4000.000 )  
    126773  S092     2021-09-14 06:31:00  4500.000   ( 4500.000 )  
    126781  S092     2021-09-14 06:38:00  14000.000  ( 4500.000 )  


------------------------------------------------------------------------
-- BOOSTER QUIZ 11-5-2
------------------------------------------------------------------------
문제) 아래 SQL은 3개월간의 주문에 대해 상품카테고리별, 월별 주문금액 합계를 구하고 있습니다.
아래 SQL을 활용해, 레코드별로 상품카테고리별 전월의 주문금액과 레코드별로 상품카테고리별 전월 대비 주문금액 증감 수치를 구해주세요.
  ㅁ 조회 조건: 아래 SQL을 활용
  ㅁ 조회 항목: ord_amt_sum_bf_cat, ord_amt_sum_cat_diff를 추가
    ㅇ ord_amt_sum_bf_cat: 상품카테고리별 전월의 주문금액입니다.
    ㅇ ord_amt_sum_cat_diff
      - 상품카테고리별 전월 대비 주문금액 증감 수치입니다.
      - 현재 월의 주문금액(ord_amt_sum)에서 ord_amt_sum_bf_cat를 뺀 값입니다.
  ㅁ 추가 고려 사항
    ㅇ 아래 SQL을 인라인 뷰로 처리 후 LAG나 LEAD 분석함수를 활용해 처리합니다.

결과)
    SELECT  t4.item_cat 
            ,MAX(t4.item_cat_nm) item_cat_nm
            ,DATE_FORMAT(t1.ord_dtm,'%Y%m') ord_ym
            ,SUM(t2.ord_qty * t2.sale_prc) ord_amt_sum
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.tr_ord_det t2
                ON (t2.ord_no = t1.ord_no)
            INNER JOIN startdbmy.ms_item t3
                ON (t3.item_id = t2.item_id)
            INNER JOIN startdbmy.ms_item_cat t4
                ON (t4.item_cat = t3.item_cat)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20220101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20220401','%Y%m%d')
    GROUP BY t4.item_cat ,DATE_FORMAT(t1.ord_dtm,'%Y%m')
    ORDER BY t4.item_cat ,DATE_FORMAT(t1.ord_dtm,'%Y%m');

    -- ord_amt_sum_bf_cat와 ord_amt_sum_cat_diff가 추가된 결과
    item_cat  item_cat_nm  ord_ym  ord_amt_sum   ord_amt_sum_bf_cat  ord_amt_sum_cat_diff
    --------  -----------  ------  ------------  ------------------  --------------------  
    BEV       Beverage     202201  5249500.000   NULL                NULL                  
    BEV       Beverage     202202  4774500.000   5249500.000         -475000.000           
    BEV       Beverage     202203  5681500.000   4774500.000         907000.000            
    BKR       Bakery       202201  4144500.000   NULL                NULL                  
    BKR       Bakery       202202  3857000.000   4144500.000         -287500.000           
    BKR       Bakery       202203  3993500.000   3857000.000         136500.000            
    COF       Coffee       202201  31024000.000  NULL                NULL                  
    COF       Coffee       202202  28469000.000  31024000.000        -2555000.000          
    COF       Coffee       202203  31573500.000  28469000.000        3104500.000           

답안)
SELECT t4.item_cat,
        MAX(t4.item_cat_nm) item_cat_nm,
        DATE_FORMAT(t1.ord_dtm,'%Y%m') ord_ym,
        SUM(t2.ord_qty * t2.sale_prc) ord_amt_sum,
        LAG(SUM(t2.ord_qty * t2.sale_prc)) OVER(PARTITION BY t4.item_cat ORDER BY DATE_FORMAT(t1.ord_dtm,'%Y%m')) ord_amt_sum_bf_cat,
        SUM(t2.ord_qty * t2.sale_prc) - LAG(SUM(t2.ord_qty * t2.sale_prc)) OVER(PARTITION BY t4.item_cat ORDER BY DATE_FORMAT(t1.ord_dtm,'%Y%m')) ord_amt_sum_cat_diff
FROM startdbmy.tr_ord t1
JOIN startdbmy.tr_ord_det t2
ON t1.ord_no = t2.ord_no
JOIN startdbmy.ms_item t3
ON t2.item_id = t3.item_id
JOIN startdbmy.ms_item_cat t4
ON t3.item_cat = t4.item_cat
WHERE t1.ord_dtm >= STR_TO_DATE('20220101','%Y%m%d')
AND t1.ord_dtm < STR_TO_DATE('20220401','%Y%m%d')
GROUP BY t4.item_cat, DATE_FORMAT(t1.ord_dtm,'%Y%m')
ORDER BY t4.item_cat, ord_ym;




