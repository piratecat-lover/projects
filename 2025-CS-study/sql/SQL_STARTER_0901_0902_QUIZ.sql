
------------------------------------------------------------------------
-- BOOSTER QUIZ 9-2-1
------------------------------------------------------------------------
문제)
아래 SQL을 인라인 뷰를 활용한 1:1 조인으로 변경하세요.
  ㅁ 추가 고려 사항: tr_ord 테이블에 대한 내용을 인라인 뷰로 처리하세요.

  
결과)
    SELECT  t1.mbr_id ,MAX(t1.nick_nm) nick_nm
            ,SUM(t2.ord_amt) ord_amt_sum
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t2.mbr_id = t1.mbr_id)
    WHERE   t1.join_tp = 'SNS'
    AND     t1.mbr_gd = 'PLAT'
    AND     t2.ord_dtm >= STR_TO_DATE('20220301','%Y%m%d')
    AND     t2.ord_dtm <  STR_TO_DATE('20220302','%Y%m%d')
    GROUP BY t1.mbr_id
    ORDER BY ord_amt_sum DESC;

    mbr_id  nick_nm   ord_amt_sum  
    ------  --------  -----------  
    M1264   Forest25  4500.000     
    M0020   Lake      4000.000     


답안)
SELECT t1.mbr_id, t1.nick_nm, IFNULL(t2.ord_amt_sum, 0) ord_amt_sum
FROM startdbmy.ms_mbr t1
INNER JOIN (SELECT mbr_id, SUM(ord_amt) ord_amt_sum
            FROM startdbmy.tr_ord
            WHERE ord_dtm >= STR_TO_DATE('20220301','%Y%m%d')
            AND ord_dtm <  STR_TO_DATE('20220302','%Y%m%d')
            GROUP BY mbr_id) t2
ON t2.mbr_id = t1.mbr_id
WHERE t1.join_tp = 'SNS'
AND t1.mbr_gd = 'PLAT'
ORDER BY t2.ord_amt_sum DESC;







------------------------------------------------------------------------
-- BOOSTER QUIZ 9-2-2
------------------------------------------------------------------------
문제)
아래 SQL을 인라인 뷰를 활용한 1:1 조인으로 변경하세요.
  ㅁ 추가 고려 사항: tr_ord 테이블에 대한 내용을 인라인 뷰로 처리하세요.

결과)
    SELECT  t1.mbr_gd ,MAX(t1.nick_nm) nick_nm
            ,COUNT(*) ord_cnt ,SUM(t2.ord_amt) ord_amt_sum
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t2.mbr_id = t1.mbr_id)
    WHERE   t1.join_dtm = STR_TO_DATE('20190323','%Y%m%d')
    AND     t2.ord_dtm >= STR_TO_DATE('20210101','%Y%m%d')
    AND     t2.ord_dtm <  STR_TO_DATE('20220101','%Y%m%d')
    GROUP BY t1.mbr_gd
    ORDER BY ord_amt_sum DESC;

    mbr_gd  nick_nm   ord_cnt  ord_amt_sum  
    ------  --------  -------  -----------  
    GOLD    Wind3     444      3105000.000  
    SILV    Thunder3  210      1397000.000  
    PLAT    Galaxy16  62       413500.000     

답안)
SELECT t1.mbr_gd, MAX(t1.nick_nm) nick_nm, SUM(t2.ord_cnt) ord_cnt, SUM(t2.ord_amt_sum) ord_amt_sum
FROM startdbmy.ms_mbr t1
INNER JOIN (SELECT mbr_id ,SUM(ord_amt) ord_amt_sum, COUNT(*) ord_cnt
            FROM startdbmy.tr_ord
            WHERE ord_dtm >= STR_TO_DATE('20210101','%Y%m%d')
            AND ord_dtm <  STR_TO_DATE('20220101','%Y%m%d')
            GROUP BY mbr_id) t2
ON t2.mbr_id = t1.mbr_id
WHERE t1.join_dtm = STR_TO_DATE('20190323','%Y%m%d')
GROUP BY t1.mbr_gd
ORDER BY t2.ord_amt_sum DESC;