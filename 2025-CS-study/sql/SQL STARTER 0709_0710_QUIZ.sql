
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-9-1
------------------------------------------------------------------------
문제)
닉네임이 ‘Air’, ‘Sky’, ‘Space’인 회원의 '2020년 1월 1일'부터 '2020년 1월 3일'까지의 주문 데이터를 조회해주세요. 주문이 없는 회원도 보여주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord
  ㅁ 조회 조건
    ㅇ nick_nm이 Air, Sky, Space인 회원
    ㅇ ord_dtm이 2020년 1월 1일부터 2020년 1월 3일까지의 데이터.
  ㅁ 조회 항목: mbr_id, nick_nm, ord_no, ord_dtm
  ㅁ 추가 고려 사항: 주문이 없는 회원도 조회되도록 처리하세요.
  ㅁ 정렬 기준: mbr_id로 오름차순 후에 ord_no로 오름차순해주세요.

결과)
    mbr_id  nick_nm  ord_no  ord_dtm             
    ------  -------  ------  ------------------- 
    M0001   Air      24629   2020-01-01 07:03:00 
    M0001   Air      24769   2020-01-02 07:03:00 
    M0001   Air      24873   2020-01-03 07:03:00 
    M0038   Sky      NULL    NULL                
    M0039   Space    NULL    NULL                

답안)
SELECT t1.mbr_id, t1.nick_nm, t2.ord_no, t2.ord_dtm
FROM ms_mbr t1
LEFT JOIN tr_ord t2 
ON (t1.mbr_id = t2.mbr_id
  AND t2.ord_dtm >= STR_TO_DATE('2020-01-01', '%Y-%m-%d')
  AND t2.ord_dtm < STR_TO_DATE('2020-01-04', '%Y-%m-%d')
)
WHERE t1.nick_nm IN ('Air', 'Sky', 'Space')
ORDER BY t1.mbr_id, t2.ord_no;


------------------------------------------------------------------------
-- BOOSTER QUIZ 7-9-2
------------------------------------------------------------------------
문제)
[BOOSTER QUIZ 7-9-1]을 활용합니다. 주문상세와 주문한 상품명도 같이 보여주세요.

  ㅁ 대상 테이블: ms_mbr, tr_ord, tr_ord_det, ms_item
  ㅁ 조회 조건
    ㅇ nick_nm이 Air, Sky, Space인 회원
    ㅇ ord_dtm이 2020년 1월 1일부터 2020년 1월 3일까지의 데이터.
  ㅁ 조회 항목: mbr_id, nick_nm, ord_no, ord_dtm, ord_det_no ,item_id ,item_nm
  ㅁ 추가 고려 사항: 주문이 없는 회원도 조회되도록 처리하세요.
  ㅁ 정렬 기준: mbr_id로 오름차순 후에 ord_no로 오름차순, ord_det_no로 오름차순 정렬해 주세요.
  

결과)
    mbr_id  nick_nm  ord_no  ord_dtm              ord_det_no  item_id  item_nm             
    ------  -------  ------  -------------------  ----------  -------  ------------------  
    M0001   Air      24629   2020-01-01 07:03:00  1           IAMR     Iced Americano(R)   
    M0001   Air      24769   2020-01-02 07:03:00  1           ICLB     Iced Cafe Latte(B)  
    M0001   Air      24873   2020-01-03 07:03:00  1           ICLB     Iced Cafe Latte(B)  
    M0001   Air      24873   2020-01-03 07:03:00  2           LEMR     Lemonade(R)         
    M0038   Sky      NULL    NULL                 NULL        NULL     NULL                
    M0039   Space    NULL    NULL                 NULL        NULL     NULL                

답안)
SELECT t1.mbr_id, t1.nick_nm, t2.ord_no, t2.ord_dtm, t3.ord_det_no, t4.item_id, t4.item_nm
FROM ms_mbr t1
LEFT JOIN tr_ord t2
ON (t1.mbr_id = t2.mbr_id
  AND t2.ord_dtm >= STR_TO_DATE('2020-01-01', '%Y-%m-%d')
  AND t2.ord_dtm < STR_TO_DATE('2020-01-04', '%Y-%m-%d')
)
LEFT JOIN tr_ord_det t3
ON t2.ord_no = t3.ord_no
LEFT JOIN ms_item t4
ON t3.item_id = t4.item_id
WHERE t1.nick_nm IN ('Air', 'Sky', 'Space')
ORDER BY t1.mbr_id, t2.ord_no, t3.ord_det_no;



------------------------------------------------------------------------
-- BOOSTER QUIZ 7-10-1
------------------------------------------------------------------------
문제)
닉네임이 ‘Air’, ‘Sky’, ‘Space’인 회원의 '2020년 1월 1일'부터 '2020년 1월 3일'까지의 주문건수와 주문금액을 집계해주세요.
주문이 없는 회원은 주문건수와 주문금액을 0으로 출력되도록 처리해주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord
  ㅁ 조회 조건
    ㅇ nick_nm이 Air, Sky, Space인 회원
    ㅇ ord_dtm이 2020년 1월 1일부터 2020년 1월 3일까지의 데이터.
  ㅁ 조회 항목: mbr_id, nick_nm, ord_cnt, ord_amt_sum
    ㅇ ord_cnt: mbr_id별로 집계된 주문 건수입니다.
    ㅇ ord_amt_sum: mbr_id별로 ord_amt를 SUM 처리한 결과입니다.
  ㅁ 추가 고려 사항: 주문이 없는 회원은 ord_cnt와 ord_amt_sum을 0으로 보여주세요.
  ㅁ 정렬 기준: mbr_id로 오름차순 정렬해주세요.

결과)
    mbr_id  nick_nm  ord_cnt  ord_amt_sum    
    ------  -------  -------  -------------
    M0001   Air      3        16500.000  
    M0038   Sky      0        0.000      
    M0039   Space    0        0.000      

답안)
SELECT t1.mbr_id, t1.nick_nm, COUNT(t2.ord_no) ord_cnt, IFNULL(SUM(t2.ord_amt), 0) ord_amt_sum
FROM ms_mbr t1
LEFT JOIN tr_ord t2
ON (t1.mbr_id = t2.mbr_id
  AND t2.ord_dtm >= STR_TO_DATE('2020-01-01', '%Y-%m-%d')
  AND t2.ord_dtm < STR_TO_DATE('2020-01-04', '%Y-%m-%d')
)
WHERE t1.nick_nm IN ('Air', 'Sky', 'Space')
GROUP BY t1.mbr_id, t1.nick_nm
ORDER BY t1.mbr_id;



