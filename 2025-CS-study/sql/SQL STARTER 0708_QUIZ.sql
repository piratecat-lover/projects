
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-8-1
------------------------------------------------------------------------
문제)
'M4547' 회원의 '2024년 1월 5일' 주문 정보와 주문상세 정보를 보여주세요.
주문 시점의 판매가격 정보도 보여주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord, tr_ord_det, ms_item_prc_hist
  ㅁ 조회 조건
    ㅇ ms_mbr: mbr_id가 M4547인 회원
    ㅇ tr_ord: ord_dtm이 2024년 1월 5일
  ㅁ 조회 항목: mbr_id ,nick_nm, join_dtm, ord_dtm, item_id, prc_start_dt, sale_prc
    ㅇ sale_prc: 주문 시점의 판매가격입니다. ms_item_prc_hist 테이블을 활용해 처리해 주세요.
  ㅁ 정렬 기준: ord_dtm으로 오름차순 한 후에, item_id로 오름차순 해주세요.


결과)
    mbr_id  nick_nm  join_dtm             ord_dtm              item_id  prc_start_dt  sale_prc  
    ------  -------  -------------------  -------------------  -------  ------------  --------  
    M4547   Swift90  2022-05-15 00:00:00  2024-01-05 06:32:00  IAMR     2023-01-01    4500.000  
    M4547   Swift90  2022-05-15 00:00:00  2024-01-05 07:02:00  AMB      2023-01-01    4500.000  
    M4547   Swift90  2022-05-15 00:00:00  2024-01-05 07:02:00  FLTR     2024-01-01    5400.000  

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.join_dtm, t2.ord_dtm, t3.item_id, t4.prc_start_dt, t4.sale_prc
FROM ms_mbr t1
JOIN tr_ord t2 ON t1.mbr_id = t2.mbr_id
JOIN tr_ord_det t3 ON t2.ord_no = t3.ord_no
JOIN ms_item_prc_hist t4 
  ON (t3.item_id = t4.item_id
  AND t4.prc_start_dt <= DATE(t2.ord_dtm)
  AND t4.prc_end_dt >= DATE(t2.ord_dtm)
  )
WHERE t1.mbr_id = 'M4547'
  AND t2.ord_dtm >= STR_TO_DATE('2024-01-05', '%Y-%m-%d')
  AND t2.ord_dtm < STR_TO_DATE('2024-01-06', '%Y-%m-%d')
ORDER BY t2.ord_dtm, t3.item_id;

    

------------------------------------------------------------------------
-- BOOSTER QUIZ 7-8-2
------------------------------------------------------------------------
문제)
[BOOSTER QUIZ 7-8-1]의 SQL에 회원의 가입일시 시점에 해당하는 상품의 판매가격도 추가해서 보여주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord, tr_ord_det, ms_item_prc_hist
  ㅁ 조회 조건
    ㅇ ms_mbr: mbr_id가 M4547인 회원
    ㅇ tr_ord: ord_dtm이 2024년 1월 5일
  ㅁ 추가 항목: sale_prc_join
    ㅇ sale_prc_join
      - 기존 SQL에 ms_item_prc_hist 조인을 하나 더 추가합니다.
      - 회원 가입일시 시점의 해당 상품의 판매가격입니다.
      - ms_mbr의 join_dtm과 tr_ord_det의 Item을 조인 조건으로 사용합니다.
  ㅁ 정렬 기준: ord_dtm으로 오름차순 한 후에, item_id로 오름차순 해주세요.
  
결과)
    mbr_id  nick_nm  join_dtm             ord_dtm              item_id  prc_start_dt  sale_prc  sale_prc_join  
    ------  -------  -------------------  -------------------  -------  ------------  --------  -------------  
    M4547   Swift90  2022-05-15 00:00:00  2024-01-05 06:32:00  IAMR     2023-01-01    4500.000  4000.000       
    M4547   Swift90  2022-05-15 00:00:00  2024-01-05 07:02:00  AMB      2023-01-01    4500.000  4000.000       

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.join_dtm, t2.ord_dtm, t3.item_id, t4.prc_start_dt, t4.sale_prc, t5.sale_prc AS sale_prc_join
FROM ms_mbr t1
JOIN tr_ord t2 ON t1.mbr_id = t2.mbr_id
JOIN tr_ord_det t3 ON t2.ord_no = t3.ord_no
JOIN ms_item_prc_hist t4 
  ON (t3.item_id = t4.item_id
  AND t4.prc_start_dt <= DATE(t2.ord_dtm)
  AND t4.prc_end_dt >= DATE(t2.ord_dtm)
  )
JOIN ms_item_prc_hist t5
  ON (t3.item_id = t5.item_id
  AND t5.prc_start_dt <= DATE(t1.join_dtm)
  AND t5.prc_end_dt >= DATE(t1.join_dtm)
  )
WHERE t1.mbr_id = 'M4547'
  AND t2.ord_dtm >= STR_TO_DATE('2024-01-05', '%Y-%m-%d')
  AND t2.ord_dtm < STR_TO_DATE('2024-01-06', '%Y-%m-%d')
ORDER BY t2.ord_dtm, t3.item_id;