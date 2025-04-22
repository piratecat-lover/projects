------------------------------------------------------------------------
-- BOOSTER QUIZ 9-3-1
------------------------------------------------------------------------
문제)
아래 SQL을 tr_ord(주문)와 ms_shop(매장)을 별도 인라인 뷰에서 조인 및 GROUP BY 처리한 후에 ms_mbr(회원)과 조인되는 방식으로 수정하세요.

SELECT  t1.mbr_id ,COUNT(*) ord_cnt
FROM    startdbmy.ms_mbr t1
        INNER JOIN startdbmy.tr_ord t2
            ON (t2.mbr_id = t1.mbr_id)
        INNER JOIN startdbmy.ms_shop t3
            ON (t3.shop_id = t2.shop_id)
WHERE   t1.join_dtm = STR_TO_DATE('20190329','%Y%m%d')
AND     t2.ord_dtm >= STR_TO_DATE('20200101','%Y%m%d')
AND     t2.ord_dtm <  STR_TO_DATE('20200401','%Y%m%d')
AND     t3.shop_size < 50
GROUP BY t1.mbr_id
ORDER BY ord_cnt DESC;


결과)

    mbr_id  ord_cnt  
    ------  -------  
    M0008   91       
    M0009   91       
    M0309   6        
    M0341   3        
    M0050   3        
    M0051   3        
    M0552   3        
    M0241   3        
    M0650   3        
    M0744   3        
    M0749   3        
    M0842   3        
    M0351   3        
    M0847   3        
    M0449   3        

답안)
SELECT t1.mbr_id, t2.ord_cnt
FROM startdbmy.ms_mbr t1
JOIN (SELECT a.mbr_id, COUNT(*) ord_cnt
      FROM startdbmy.tr_ord a, 
           startdbmy.ms_shop b
      WHERE a.shop_id = b.shop_id
      AND a.ord_dtm >= STR_TO_DATE('20200101','%Y%m%d')
      AND a.ord_dtm <  STR_TO_DATE('20200401','%Y%m%d')
      AND b.shop_size < 50
      GROUP BY a.mbr_id) t2 ON (t1.mbr_id = t2.mbr_id)
WHERE t1.join_dtm = STR_TO_DATE('20190329','%Y%m%d')
ORDER BY ord_cnt DESC;








------------------------------------------------------------------------
-- BOOSTER QUIZ 9-4-1
------------------------------------------------------------------------
문제)
2019년 3월 27일에 가입한 플래티넘 등급 회원에 대해, 회원별 2020년부터 2022년까지의 주문금액과 같은 기간의 이벤트응모횟수를 보여주세요.
응모나 주문이 한번도 없는 회원도 출력되도록 해주세요.

  ㅁ 대상 테이블: ms_mbr, tr_ord, tr_event_entry(이벤트응모)
  ㅁ 조회 조건
    ㅇ ms_mbr: join_dtm이 2019년 3월 27일이면서, mbr_gd가 PLAT인 회원
    ㅇ tr_ord: ord_dtm이 2020년 1월 1일 이상, 2023년 1월 1일 미만
    ㅇ tr_event_entry: entry_dtm(응모일시)이 2020년 1월 1일 이상, 2023년 1월 1일 미만
  ㅁ 조회 항목: mbr_id, nick_nm, ord_amt_sum, entry_cnt
    ㅇ ord_amt_sum: mbr_id별 ord_amt의 합계
    ㅇ entry_cnt: mbr_id별 이벤트응모 건수
  ㅁ 추가 고려 사항
    ㅇ tr_ord와 tr_event_entry를 각각의 인라인 뷰에서 GROUP BY 처리 후 조인하세요.
      - 인라인 뷰를 활용해 1:1:1 조인이 되도록 처리합니다.
    ㅇ 주문이나 이벤트응모가 없는 회원도 조회될 수 있도록 아우터 조인 처리하세요.
     - ms_mbr을 기준집합으로 처리합니다.
  ㅁ 정렬 기준: mbr_id로 오름차순 정렬해주세요.

결과)
    mbr_id  nick_nm   ord_amt_sum  entry_cnt  
    ------  --------  -----------  ---------  
    M0017   Gold      7385000.000  0          
    M0087   Silver1   732500.000   36         
    M0197   Swift3    434000.000   3          
    M0314   Forest6   264000.000   0          
    M0337   Silver6   221000.000   0          
    M0356   Copper7   296000.000   0          
    M0567   Gold11    229500.000   0          
    M0606   Copper12  0.000        0          
    M0634   River12   231500.000   0          

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.ord_amt_sum, COUNT(t2.entry_no) entry_cnt
FROM (SELECT a.mbr_id, a.nick_nm, IFNULL(SUM(b.ord_amt), 0) ord_amt_sum
      FROM startdbmy.ms_mbr a
      LEFT JOIN startdbmy.tr_ord b
      ON (a.mbr_id = b.mbr_id
	      AND b.ord_dtm >= STR_TO_DATE('20200101','%Y%m%d')
	      AND b.ord_dtm <  STR_TO_DATE('20230101','%Y%m%d')
	     )
      WHERE a.join_dtm >= STR_TO_DATE('20190327','%Y%m%d')
      AND a.join_dtm <  STR_TO_DATE('20190328','%Y%m%d')
      AND a.mbr_gd = 'PLAT'
      GROUP BY a.mbr_id, a.nick_nm
      ) t1
LEFT JOIN startdbmy.tr_event_entry t2
ON (t1.mbr_id = t2.mbr_id
    AND t2.entry_dtm >= STR_TO_DATE('20200101','%Y%m%d')
    AND t2.entry_dtm <  STR_TO_DATE('20230101','%Y%m%d')
)
GROUP BY t1.mbr_id
ORDER BY t1.mbr_id ASC;