
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-12-1
------------------------------------------------------------------------
문제)
2020년부터 2023년까지의 주문에 대해 년도별 주문건수와 년도별 주문이 존재하는 회원수를 보여주세요.
주문건수와 주문이 존재하는 회원수를 각각의 레코드로 구분해서 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2020년 1월 1일부터 2023년 12월 31일까지 데이터
  ㅁ 조회 항목: ord_yy, 값구분, val
    ㅇ ord_yy: ord_dtm을 년도로 변환한 값입니다.
    ㅇ 값구분: 해당 년도의 레코드가 주문건수인지 주문존재회원수인지를 구분합니다.
    ㅇ val
      - 값구분이 주문건수인 경우에는 주문을 카운트한 값입니다.
      - 값구분이 주문존재회원수인 경우에는 주문이 존재하는 회원 수입니다.
        : COUNT(DISTINCT mbr_id)를 활용해 처리합니다.
  ㅁ 추가 고려 사항
     ㅇ ord_yy 별로 GROUP BY 처리합니다.
     ㅇ UNION ALL을 활용해 처리합니다.
  ㅁ 정렬 기준: ord_yy로 오름차순 후에 값구분으로 오름차순 정렬해주세요.

결과)
    ord_yy  값구분          val  
    ------  --------------  -------  
    2020    주문건수        55733    
    2020    주문존재회원수  2490     
    2021    주문건수        68555    
    2021    주문존재회원수  2970     
    2022    주문건수        148742   
    2022    주문존재회원수  9880     
    2023    주문건수        209370   
    2023    주문존재회원수  9688     

답안)
SELECT DATE_FORMAT(ord_dtm, '%Y') AS ord_yy, '주문건수' 값구분, COUNT(ord_no) val
FROM tr_ord
WHERE ord_dtm >= STR_TO_DATE('2020-01-01', '%Y-%m-%d')
  AND ord_dtm < STR_TO_DATE('2024-01-01', '%Y-%m-%d')
GROUP BY DATE_FORMAT(ord_dtm, '%Y')
UNION ALL
SELECT DATE_FORMAT(ord_dtm, '%Y') AS ord_yy, '주문존재회원수' 값구분, COUNT(DISTINCT mbr_id) val
FROM tr_ord
WHERE ord_dtm >= STR_TO_DATE('2020-01-01', '%Y-%m-%d')
  AND ord_dtm < STR_TO_DATE('2024-01-01', '%Y-%m-%d')
GROUP BY DATE_FORMAT(ord_dtm, '%Y')
ORDER BY ord_yy, 값구분;