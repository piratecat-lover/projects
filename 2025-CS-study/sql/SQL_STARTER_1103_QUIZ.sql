

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-3-1
------------------------------------------------------------------------
문제)
2022년 1월 주문에 대해, 상품카테고리별 주문수량을 구해주세요. 상품카테고리별 주문수량에 대한 순위도 구해주세요.
  ㅁ 대상 테이블: tr_ord, tr_ord_det, ms_item, ms_item_cat
  ㅁ 조회 조건: ord_dtm이 2022년 1월인 주문 데이터
  ㅁ 조회 항목: item_cat, item_cat_nm, ord_qty_sum, ord_qty_sum_rank_ov
    ㅇ ord_qty_sum: item_cat별, ord_qty의 합계
    ㅇ ord_qty_sum_rank_ov: ord_qty_sum에 대한 순위입니다.
      - ord_qty_sum이 가장 많으면 1위가 됩니다.

결과)
    item_cat  item_cat_nm  ord_qty_sum  ord_qty_sum_rank_ov  
    --------  -----------  -----------  -------------------  
    COF       Coffee       7307         1                    
    BKR       Bakery       1472         2                    
    BEV       Beverage     1369         3                    

답안)



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-3-2
------------------------------------------------------------------------
문제)
2022년 1월 주문에 대해, 매장운영유형별 주문금액을 구해주세요. 조회된 전체주문금액에 대해 매장운영유형별 주문금액 비율(%)도 구해주세요.
  ㅁ 대상 테이블: ms_shop, tr_ord, cm_base_cd
  ㅁ 조회 조건: ord_dtm이 2022년 1월인 주문데이터
  ㅁ 조회 항목: shop_oper_tp, shop_oper_tp_nm, ord_amt_sum, ord_amt_sum_pct
    ㅇ shop_oper_tp_nm: shop_oper_tp에 대한 명칭입니다. cm_base_cd로 해결하세요.
    ㅇ ord_amt_sum: shop_oper_tp별 ord_amt의 합계입니다.
    ㅇ ord_amt_sum_pct: 조회된 레코드의 전체주문금액에 대한 ord_amt_sum의 비율입니다.
       - 조회된 레코드의 전체주문금액을 ord_amt_sum_ov라고 했을때, 아래 로직으로 해결합니다.
       - ROUND(ord_amt_sum / ord_amt_sum_ov * 100, 2)
  ㅁ 추가 조건
    ㅇ shop_oper_tp별 GROUP BY 처리합니다.
    ㅇ 분석함수를 사용해 전체주문금액을 구합니다.
  ㅁ 정렬 기준: ord_amt_sum_pct로 내림차순 정렬해 주세요.
    
결과)
    shop_oper_tp  shop_oper_tp_nm  ord_amt_sum   ord_amt_sum_pct  
    ------------  ---------------  ------------  ---------------  
    DIST          Distributor      33242500.000  82.25            
    DRCT          Directly         5616500.000   13.90            
    FLAG          Flagship         1559000.000   3.86             

답안)



