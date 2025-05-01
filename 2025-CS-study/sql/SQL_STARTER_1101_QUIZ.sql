
------------------------------------------------------------------------
-- BOOSTER QUIZ 11-1-1
------------------------------------------------------------------------
문제)
(SQL-1)과 (결과-1)을 참고해, (SQL-2)를 실행하면 나올 (결과-2)를 채우세요.
  ㅁ (SQL-2)는 (SQL-1)에 분석함수만 추가한 SQL입니다.
  ㅁ SQL을 실행하지 않고 (결과-2)를 예측해서 채우세요.


결과)
    -- (SQL-1)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S092'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20210911','%Y%m%d')
    ORDER BY t1.ord_no ASC;

    -- (결과-1)
    ord_no  shop_id  ord_dtm              ord_amt   
    ------  -------  -------------------  --------  
    124121  S092     2021-09-03 06:32:00  4500.000  
    124135  S092     2021-09-03 06:36:00  4000.000  
    125684  S092     2021-09-09 06:32:00  4000.000  
    125994  S092     2021-09-10 06:31:00  4500.000  

    -- (SQL-2)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm, t1.ord_amt
            ,SUM(t1.ord_amt) OVER() ord_amt_sum_ov
            ,COUNT(*) OVER() ord_cnt_ov
            ,MAX(t1.ord_dtm) OVER() max_dtm_ov
    FROM    startdbmy.tr_ord t1
    WHERE   t1.shop_id = 'S092'
    AND     t1.ord_dtm>=STR_TO_DATE('20210901','%Y%m%d')
    AND     t1.ord_dtm< STR_TO_DATE('20210911','%Y%m%d')
    ORDER BY t1.ord_no ASC;

    -- (결과-2)
    ord_no  shop_id  ord_dtm              ord_amt   ord_amt_sum_ov  ord_cnt_ov  max_dtm_ov           
    ------  -------  -------------------  --------  --------------  ----------  -------------------  
    124121  S092     2021-09-03 06:32:00  4500.000  (            )  (        )  (                  )  
    124135  S092     2021-09-03 06:36:00  4000.000  (            )  (        )  (                  )  
    125684  S092     2021-09-09 06:32:00  4000.000  (            )  (        )  (                  )  
    125994  S092     2021-09-10 06:31:00  4500.000  (            )  (        )  (                  )  

답안)
    ord_no  shop_id  ord_dtm              ord_amt   ord_amt_sum_ov  ord_cnt_ov  max_dtm_ov           
    ------  -------  -------------------  --------  --------------  ----------  -------------------  
    124121  S092     2021-09-03 06:32:00  4500.000  (   4500     )  (   4    )  (2021-09-10 06:31:00)  
    124135  S092     2021-09-03 06:36:00  4000.000  (   4500     )  (   4    )  (2021-09-10 06:31:00)  
    125684  S092     2021-09-09 06:32:00  4000.000  (   4500     )  (   4    )  (2021-09-10 06:31:00)  
    125994  S092     2021-09-10 06:31:00  4500.000  (   4500     )  (   4    )  (2021-09-10 06:31:00)  


------------------------------------------------------------------------
-- BOOSTER QUIZ 11-1-2
------------------------------------------------------------------------
(SQL-1)과 (결과-1)을 참고해, (SQL-2)를 실행하면 나올 (결과-2)를 채우세요.
  ㅁ (SQL-2)는 (SQL-1)에 분석함수만 추가한 SQL입니다.
  ㅁ SQL을 실행하지 않고 (결과-2)를 예측해서 채우세요.


결과)
    -- (SQL-1)
    SELECT  t1.shop_id ,t1.shop_nm ,t1.chair_qty
    FROM    startdbmy.ms_shop t1
    WHERE   t1.shop_oper_tp = 'FLAG'
    AND     EXISTS(
                SELECT  COUNT(*)
                FROM    startdbmy.tr_ord X
                WHERE   X.shop_id = t1.shop_id
                AND     X.ord_dtm >= STR_TO_DATE('20211101','%Y%m%d')
                AND     X.ord_dtm <  STR_TO_DATE('20211201','%Y%m%d')
                HAVING COUNT(*) >= 30
                )
    ORDER BY t1.shop_id;

    -- (결과-1)
    shop_id  shop_nm           chair_qty  
    -------  ----------------  ---------  
    S014     Columbus-1st      23         
    S022     Los Angeles-2nd   20         
    S026     Philadelphia-2nd  34         

    -- (SQL-2)
    SELECT  t1.shop_id ,t1.shop_nm ,t1.chair_qty
            ,COUNT(*) OVER() shop_cnt_ov
            ,SUM(t1.chair_qty) OVER() chair_qty_sum_ov
    FROM    startdbmy.ms_shop t1
    WHERE   t1.shop_oper_tp = 'FLAG'
    AND     EXISTS(
                SELECT  COUNT(*)
                FROM    startdbmy.tr_ord X
                WHERE   X.shop_id = t1.shop_id
                AND     X.ord_dtm >= STR_TO_DATE('20211101','%Y%m%d')
                AND     X.ord_dtm <  STR_TO_DATE('20211201','%Y%m%d')
                HAVING COUNT(*) >= 30
                )
    ORDER BY t1.shop_id;

    -- (결과-2)
    shop_id  shop_nm           chair_qty  shop_cnt_ov  chair_qty_sum_ov  
    -------  ----------------  ---------  -----------  ----------------  
    S014     Columbus-1st      23         (          ) (               )
    S022     Los Angeles-2nd   20         (          ) (               )
    S026     Philadelphia-2nd  34         (          ) (               )

답안)
    shop_id  shop_nm           chair_qty  shop_cnt_ov  chair_qty_sum_ov  
    -------  ----------------  ---------  -----------  ----------------  
    S014     Columbus-1st      23         (     3    ) (       77      )
    S022     Los Angeles-2nd   20         (     3    ) (       77      )
    S026     Philadelphia-2nd  34         (     3    ) (       77      )


------------------------------------------------------------------------
-- BOOSTER QUIZ 11-1-3
------------------------------------------------------------------------

문제)
M0888 회원의 2022년 1월 1일 주문 목록을 조회해 주세요. 조회된 주문에 대한 전체주문금액과 전체주문건수도 컬럼으로 추가해서 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: mbr_id는 M0888이고 ord_dtm이 2022년 1월 1일인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, mbr_id, ord_amt, ord_amt_sum_ov, ord_cnt_ov
    ㅇ ord_amt_sum_ov: 조회된 데이터에 대한 ord_amt의 합계입니다.
    ㅇ ord_cnt_ov: 조회된 데이터의 건수입니다.
  ㅁ 추가 고려 사항:
    ㅇ ord_amt_sum_ov와 ord_cnt_ov는 분석함수로 처리합니다.
  ㅁ 정렬 기준: ord_no로 오름차순 정렬해 주세요.
  
결과)
    ord_no  ord_dtm              mbr_id  ord_amt   ord_amt_sum_ov  ord_cnt_ov  
    ------  -------------------  ------  --------  --------------  ----------  
    149013  2022-01-01 07:26:00  M0888   8000.000  20000.000       4           
    149028  2022-01-01 08:30:00  M0888   4000.000  20000.000       4           
    149032  2022-01-01 09:02:00  M0888   4000.000  20000.000       4           
    149033  2022-01-01 09:55:00  M0888   4000.000  20000.000       4           

답안)
SELECT t1.ord_no, t1.ord_dtm, t1.mbr_id, t1.ord_amt, SUM(t1.ord_amt) OVER() ord_amt_sum_ov, COUNT(*) OVER() ord_cnt_ov
FROM startdbmy.tr_ord t1
WHERE t1.mbr_id = 'M0888'
AND t1.ord_dtm >= STR_TO_DATE('20220101','%Y%m%d')
AND t1.ord_dtm < STR_TO_DATE('20220102','%Y%m%d')
ORDER BY t1.ord_no;



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-1-4
------------------------------------------------------------------------
문제)
[BOOSTER QUIZ 11-1-3]의 SQL을 인라인 뷰로 처리한 후에, 각 레코드별로 ord_amt_sum_ov(전체주문금액) 대비 ord_amt의 비율도 구해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: mbr_id는 M0888이고 ord_dtm이 2022년 1월 1일인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, mbr_id, ord_amt, ord_amt_sum_ov, ord_cnt_ov, ord_amt_rat_sum
    ㅇ ord_amt_rat_sum: ord_amt / ord_amt_sum_ov의 결과입니다. 소수점 두 자리까지 반올림해 주세요.
  ㅁ 추가 고려 사항:
    ㅇ [BOOSTER QUIZ 11-1-3]의 SQL을 인라인 뷰로 처리합니다.

결과)

    ord_no  ord_dtm              mbr_id  ord_amt   ord_amt_sum_ov  ord_cnt_ov  ord_amt_rat_sum  
    ------  -------------------  ------  --------  --------------  ----------  ---------------  
    149013  2022-01-01 07:26:00  M0888   8000.000  20000.000       4           0.40             
    149028  2022-01-01 08:30:00  M0888   4000.000  20000.000       4           0.20             
    149032  2022-01-01 09:02:00  M0888   4000.000  20000.000       4           0.20             
    149033  2022-01-01 09:55:00  M0888   4000.000  20000.000       4           0.20             

답안)
SELECT t1.ord_no, t1.ord_dtm, t1.mbr_id, t1.ord_amt, t1.ord_amt_sum_ov, t1.ord_cnt_ov, ROUND(t1.ord_amt / t1.ord_amt_sum_ov, 2) ord_amt_rat_sum
FROM (SELECT t1.ord_no, t1.ord_dtm, t1.mbr_id, t1.ord_amt, SUM(t1.ord_amt) OVER() ord_amt_sum_ov, COUNT(*) OVER() ord_cnt_ov
      FROM startdbmy.tr_ord t1
      WHERE t1.mbr_id = 'M0888'
      AND t1.ord_dtm >= STR_TO_DATE('20220101','%Y%m%d')
      AND t1.ord_dtm < STR_TO_DATE('20220102','%Y%m%d')
     ) t1
ORDER BY t1.ord_no;



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-1-5
------------------------------------------------------------------------
아래 SQL은, 의자수(chair_qty)가 70개 이상인 매장을 출력하고 있습니다. chair_qty_max(최대 의자수)와 chair_qty_rat_max(최대 의자수 대비 현재 매장의 의자수 비율)를 같이 출력하고 있습니다.
chair_qty_max와 chair_qty_rat_max를 분석함수를 사용한 방법으로 변경해 주세요.
  ㅁ 추가 고려 사항
    ㅇ 아래 SQL은 서브쿼리와 메인쿼리가 동일한 데이터에 접근하기 때문에 분석함수로 변경이 가능합니다.

결과)
    SELECT  t1.shop_id
            ,t1.shop_nm
            ,t1.chair_qty
            ,(SELECT MAX(x.chair_qty) FROM startdbmy.ms_shop x WHERE x.chair_qty >= 70) chair_qty_max
            ,ROUND(t1.chair_qty / 
                    (SELECT MAX(x.chair_qty) FROM startdbmy.ms_shop x WHERE x.chair_qty >= 70)
                  ,2) chair_qty_rat_max
    FROM    startdbmy.ms_shop t1
    WHERE   t1.chair_qty >= 70
    ORDER BY t1.chair_qty DESC;

    shop_id  shop_nm           chair_qty  chair_qty_max  chair_qty_rat_max  
    -------  ----------------  ---------  -------------  -----------------  
    S099     Denver-5th        78         78             1.00               
    S098     Seattle-5th       75         78             0.96               
    S089     Dallas-5th        73         78             0.94               
    S199     Denver-10th       73         78             0.94               
    S088     San Diego-5th     70         78             0.90               
    S097     Indianapolis-5th  70         78             0.90               
    S198     Seattle-10th      70         78             0.90               


답안)
SELECT t1.shop_id, t1.shop_nm, t1.chair_qty, MAX(t1.chair_qty) OVER() chair_qty_max, ROUND(t1.chair_qty / MAX(t1.chair_qty) OVER(), 2) chair_qty_rat_max
FROM startdbmy.ms_shop t1
WHERE t1.chair_qty >= 70
ORDER BY t1.chair_qty DESC;