
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-7-1
------------------------------------------------------------------------
문제)
주문번호 1번(ord_no=1)에 대한 매장, 회원, 상품, 주문수량 등의 모든 정보를 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord), 매장(ms_shop), 회원(ms_mbr), 주문상세(tr_ord_det), 상품(ms_item)
  ㅁ 조회 조건: ord_no가 1인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, shop_nm, nick_nm, ord_det_no, ord_qty, item_nm
  ㅁ 정렬 기준: ord_det_no로 오름차순 정렬해주세요.

결과)
    ord_no  ord_dtm              shop_nm         nick_nm  ord_det_no  ord_qty  item_nm             
    ------  -------------------  --------------  -------  ----------  -------  ------------------  
    1       2019-03-16 07:01:00  Fort Worth-2nd  Pink     1           2        Iced Cafe Latte(R)  
    1       2019-03-16 07:01:00  Fort Worth-2nd  Pink     2           2        Lemonade(R)         

답안)

SELECT t1.ord_no, t1.ord_dtm, t2.shop_nm, t3.nick_nm, t4.ord_det_no, t4.ord_qty, t5.item_nm
FROM tr_ord t1
JOIN ms_shop t2 ON t1.shop_id = t2.shop_id
JOIN ms_mbr t3 ON t1.mbr_id = t3.mbr_id
JOIN tr_ord_det t4 ON t1.ord_no = t4.ord_no
JOIN ms_item t5 ON t4.item_id = t5.item_id
WHERE t1.ord_no = 1
ORDER BY t4.ord_det_no ASC;



  

------------------------------------------------------------------------
-- BOOSTER QUIZ 7-7-2
------------------------------------------------------------------------

문제) 
직영점이면서 매장면적이 100 이하이고 플래티넘 회원에 대한 2022년 12월 24일의 주문을 조회해주세요.
주문, 매장, 회원, 주문상세 등의 모든 정보를 보여주세요.
  ㅁ 대상 테이블: 매장(ms_shop), 회원(ms_mbr), 주문(tr_ord), 주문상세(tr_ord_det), 상품(ms_item)
  ㅁ 조회 조건
    ㅇ shop_oper_tp가 DRCT(직영점)이고, shop_size가 100 이하이면서
    ㅇ ord_dtm이 2022년 12월 24일인 데이터
    ㅇ mbr_gd가 PLAT이고,
  ㅁ 조회 항목: ord_no, ord_dtm, shop_nm, shop_size, item_id, item_nm, ord_qty
  ㅁ 정렬 기준: ord_no로 오름차순 후, ord_det_no로 오름차순세요.

  
결과)
    ord_no  ord_dtm              shop_nm          shop_size  item_id  item_nm              ord_qty  
    ------  -------------------  ---------------  ---------  -------  -------------------  -------  
    292288  2022-12-24 07:01:00  Seattle-1st      61         CLR      Cafe Latte(R)        1        
    292295  2022-12-24 07:01:00  San Antonio-2nd  79         ICLB     Iced Cafe Latte(B)   1        
    292295  2022-12-24 07:01:00  San Antonio-2nd  79         BMFR     Blueberry Muffin(R)  1        
    292424  2022-12-24 07:02:00  Seattle-1st      61         AMR      Americano(R)         1        
    292427  2022-12-24 07:02:00  New York-2nd     67         ICLR     Iced Cafe Latte(R)   2        
    292533  2022-12-24 07:04:00  Seattle-1st      61         ICLR     Iced Cafe Latte(R)   1        
    292533  2022-12-24 07:04:00  Seattle-1st      61         BMFR     Blueberry Muffin(R)  1        
    292576  2022-12-24 07:05:00  Seattle-1st      61         CLR      Cafe Latte(R)        2        
    292644  2022-12-24 07:07:00  San Jose-1st     45         IAMB     Iced Americano(B)    1        
    292660  2022-12-24 07:08:00  Seattle-1st      61         AMB      Americano(B)         1        
    292660  2022-12-24 07:08:00  Seattle-1st      61         BGLR     Bagel(R)             1        
    292724  2022-12-24 07:12:00  Seattle-1st      61         AMR      Americano(R)         1        

답안)
SELECT t1.ord_no, t1.ord_dtm, t2.shop_nm, t2.shop_size, t4.item_id, t5.item_nm, t4.ord_qty
FROM tr_ord t1
JOIN ms_shop t2 ON t1.shop_id = t2.shop_id
JOIN ms_mbr t3 ON t1.mbr_id = t3.mbr_id
JOIN tr_ord_det t4 ON t1.ord_no = t4.ord_no
JOIN ms_item t5 ON t4.item_id = t5.item_id
WHERE t2.shop_oper_tp = 'DRCT'
AND t2.shop_size <= 100
AND t1.ord_dtm >= STR_TO_DATE('2022-12-24', '%Y-%m-%d')
AND t1.ord_dtm < STR_TO_DATE('2022-12-25', '%Y-%m-%d')
AND t3.mbr_gd = 'PLAT'
ORDER BY t1.ord_no ASC, t4.ord_det_no ASC;




------------------------------------------------------------------------
-- BOOSTER QUIZ 7-7-3
------------------------------------------------------------------------
문제)
[BOOSTER QUIZ 7-7-2]에서 구한 내용을 사용해 item_id별로 주문수량합계를 구하세요.
  ㅁ 조회 항목: item_id, item_nm, ord_qty_sum
    ㅇ item_nm: item_id별로 item_nm을 MAX 처리한 결과입니다.
    ㅇ ord_qty_sum: item_id별로 ord_qty를 SUM 처리한 결과입니다.
  ㅁ 추가 고려 사항: item_id로 GROUP BY 처리합니다.
  ㅁ 정렬 기준: ord_qty_sum으로 내림차순 정렬해주세요.
  

결과)
    item_id  item_nm              ord_qty_sum  
    -------  -------------------  -----------  
    CLR      Cafe Latte(R)        3            
    ICLR     Iced Cafe Latte(R)   3            
    BMFR     Blueberry Muffin(R)  2            
    AMR      Americano(R)         2            
    ICLB     Iced Cafe Latte(B)   1            
    IAMB     Iced Americano(B)    1            
    AMB      Americano(B)         1            
    BGLR     Bagel(R)             1                     

답안)
SELECT t4.item_id, MAX(t5.item_nm) AS item_nm, SUM(t4.ord_qty) AS ord_qty_sum
FROM tr_ord t1
JOIN ms_shop t2 ON t1.shop_id = t2.shop_id
JOIN ms_mbr t3 ON t1.mbr_id = t3.mbr_id
JOIN tr_ord_det t4 ON t1.ord_no = t4.ord_no
JOIN ms_item t5 ON t4.item_id = t5.item_id
WHERE t2.shop_oper_tp = 'DRCT'
AND t2.shop_size <= 100
AND t1.ord_dtm >= STR_TO_DATE('2022-12-24', '%Y-%m-%d')
AND t1.ord_dtm < STR_TO_DATE('2022-12-25', '%Y-%m-%d')
AND t3.mbr_gd = 'PLAT'
GROUP BY t4.item_id
ORDER BY ord_qty_sum DESC;

