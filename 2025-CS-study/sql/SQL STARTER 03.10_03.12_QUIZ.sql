
------------------------------------------------------------------------
-- BOOSTER QUIZ 3-10-1
------------------------------------------------------------------------

문제)
https://dev.mysql.com/doc/refman/8.0/en/string-functions.html를 참고해 다음 함수의 기능을 정리하세요.
  ㅁ CHAR_LENGTH: CHAR_LENGTH(str) 함수는 str의 길이를 문자 단위로 반환한다. 이 때 CHAR_LENGTH(NULL) = NULL, CHAR_LENGTH('')=0이다.
  ㅁ REPEAT: REPEAT(str, count) 함수는 str을 count만큼 반복한 문자열을 반환한다. 이 때 count가 1보다 작으면 빈 문자열 ''을 반환하고, str이나 count가 NULL이면 NULL을 반환한다.
  ㅁ TRIM: TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str) 함수, 혹은 TRIM([remstr FROM] str) 함수는 str의 양쪽 / 왼쪽 / 오른쪽에서 모든 remstr을 제거한 문자열을 반환한다. 이 때 remstr이 지정되지 않았으면 공백을 제거하고, str이나 remstr이 NULL이면 NULL을 반환한다.


------------------------------------------------------------------------
-- BOOSTER QUIZ 3-10-2
------------------------------------------------------------------------

문제)
기존의 상품ID를 왼쪽부터 0으로 채운 총 10자리의 문자열로 만들어서 조회해주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: 모든 상품 조회
  ㅁ 조회 항목: item_id, new_item_id, item_nm
    ㅇ new_item_id: 기존의 item_id를 왼쪽부터 문자 '0'으로 채운 10자리의 신규 item_id입니다.
      - Ex) AMB -> 0000000AMB, BGLR-> 000000BGLR
      - LPAD 함수를 사용해 처리하세요.

           
결과)
    item_id  new_item_id  item_nm              
    -------  -----------  -------------------  
    AMB      0000000AMB   Americano(B)        
    AMR      0000000AMR   Americano(R)        
    BGLR     000000BGLR   Bagel(R)            
    ...생략...

SELECT item_id, LPAD(item_id, 10, '0') AS new_item_id, item_nm FROM ms_item;

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-11-1
------------------------------------------------------------------------

문제)
‘S003’ 매장에서 ‘M2942’ 회원이 ‘2022년’에 주문한 목록을 보여주세요. 주문일시에 대한 연월도 추가해서 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ shop_id가 S003, mbr_id가 M2942이면서
    ㅇ 주문일시(ord_dtm)가 2022년에 속하는 모든 주문
  ㅁ 조회 항목: ord_no, shop_id, mbr_id, ord_dtm, ord_ym
    ㅇ ord_ym: ord_dtm을 DATE_FORMAT을 사용해 연월 형태 문자열로 변형한 값
  ㅁ 정렬 기준: ord_dtm으로 오름차순 정렬하세요.

결과)
    ord_no  shop_id  mbr_id  ord_dtm              ord_ym  
    ------  -------  ------  -------------------  ------  
    150526  S003     M2942   2022-01-09 07:04:00  202201  
    163494  S003     M2942   2022-03-19 07:04:00  202203  
    168393  S003     M2942   2022-04-09 07:04:00  202204  
    …생략…
    247651  S003     M2942   2022-10-09 07:08:00  202210  
    276414  S003     M2942   2022-11-29 07:08:00  202211  
    289025  S003     M2942   2022-12-19 07:08:00  202212

SELECT ord_no, shop_id, mbr_id, ord_dtm, DATE_FORMAT(ord_dtm, '%Y%m') ord_ym FROM tr_ord
WHERE shop_id = 'S003' AND mbr_id = 'M2942' AND ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2023-01-01', '%Y-%m-%d')
ORDER BY ord_dtm ASC;
   
   
------------------------------------------------------------------------
-- BOOSTER QUIZ 3-11-2
------------------------------------------------------------------------
문제)
'S023' 매장의 ‘2022년 6월 1일’ 주문에 대해 주문일시와 픽업일시, 그리고 주문에서 픽업까지 걸린 분수를 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ ord_dtm이 2022년 6월 1일, shop_id S023의 인 모든 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, pkup_dtm, 픽업까지걸린시간(분)
  ㅁ 픽업까지걸린시간(분): ord_dtm에서 pkup_dtm까지 걸린 분(MINUTE) 차이입니다.
    ㅇ TIMESTAMPDIFF를 사용해 처리하세요.
    ㅇ 픽업까지걸린시간(분)과 같이 컬럼 별칭에 괄호가 있으므로 별칭에 백틱(``)을 사용해야 합니다.
  ㅁ 정렬 기준: 픽업까지걸린시간(분)으로 오름차순 정렬하세요.

결과)
    ord_no  ord_dtm              pkup_dtm             픽업까지걸린시간(분)          
    ------  -------------------  -------------------  --------------------  
    179595  2022-06-01 06:34:00  2022-06-01 06:36:00  2                    
    179599  2022-06-01 06:36:00  2022-06-01 06:40:00  4                    
    179607  2022-06-01 06:42:00  2022-06-01 06:48:00  6                    
    179570  2022-06-01 06:32:00  2022-06-01 06:39:00  7                    
    179613  2022-06-01 06:50:00  2022-06-01 06:57:00  7                    
    179615  2022-06-01 06:51:00  2022-06-01 06:58:00  7                    
    179617  2022-06-01 06:54:00  2022-06-01 07:02:00  8                    
    179608  2022-06-01 06:42:00  2022-06-01 06:51:00  9                    

SELECT ord_no, ord_dtm, pkup_dtm, TIMESTAMPDIFF(MINUTE, ord_dtm, pkup_dtm) `픽업까지걸린시간(분)` FROM tr_ord
WHERE shop_id = 'S023' AND ord_dtm >= STR_TO_DATE('2022-06-01', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2022-06-02', '%Y-%m-%d')
ORDER BY `픽업까지걸린시간(분)` ASC;
   
   
------------------------------------------------------------------------
-- BOOSTER QUIZ 3-11-3
------------------------------------------------------------------------
문제)
'2021년 8월'에 탈퇴한 회원들의 가입일시, 탈퇴일시, 가입월, 탈퇴월을 보여주세요. 추가로 회원을 유지한 일수도 보여주세요.
  ㅁ 대상 테이블: 회원(ms_mbr)
  ㅁ 조회 조건: leave_dtm(탈퇴일시)이 2021년 8월인 회원 데이터
  ㅁ 조회 항목: mbr_id, join_dtm, leave_dtm, 가입월, 탈퇴월, 회원유지일수
    ㅇ 가입월: join_dtm을 DATE_FORMAT을 사용해 YYYY-MM 형태의 월로 변경한 항목입니다.
    ㅇ 탈퇴월: leave_dtm을 DATE_FORMAT을 사용해 YYYY-MM 형태의 월로 변경한 항목입니다.
    ㅇ 회원유지일수: join_dtm 이후 leave_dtm까지 몇 일인지 계산한 일수입니다.
      - 회원유지일수는 TIMESTAMPDIFF를 사용해 처리합니다.
  ㅁ 정렬 기준: 회원유지일수 기준으로 오름차순 정렬하세요.

결과)
    mbr_id  join_dtm             leave_dtm            가입월  탈퇴월  회원유지일수  
    ------  -------------------  -------------------  ------  ------  ------------  
    M2436   2020-05-14 00:00:00  2021-08-03 00:00:00  202005  202108  446          
    M2446   2020-05-12 00:00:00  2021-08-11 00:00:00  202005  202108  456          
    M2456   2020-05-01 00:00:00  2021-08-10 00:00:00  202005  202108  466          
    M2466   2020-04-29 00:00:00  2021-08-18 00:00:00  202004  202108  476          

SELECT mbr_id, join_dtm, leave_dtm, DATE_FORMAT(join_dtm, '%Y%m') 가입월, DATE_FORMAT(leave_dtm, '%Y%m') 탈퇴월, TIMESTAMPDIFF(DAY, join_dtm, leave_dtm) 회원유지일수 FROM ms_mbr
WHERE leave_dtm >= STR_TO_DATE('2021-08-01', '%Y-%m-%d') AND leave_dtm < STR_TO_DATE('2021-09-01', '%Y-%m-%d')
ORDER BY TIMESTAMPDIFF(DAY, join_dtm, leave_dtm) ASC;

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-11-4
------------------------------------------------------------------------
문제)
아래 SQL에서 성능적으로 문제가 있을만한 부분이 제거되도록 SQL을 수정하세요.
   
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm
    FROM    startdbmy.tr_ord t1
    WHERE   DATE_FORMAT(t1.ord_dtm,'%Y-%m-%d') = '2021-01-03'
    AND     t1.shop_id = 'S001'
    ORDER BY t1.ord_no;

SELECT t1.ord_no, t1.shop_id, t1.ord_dtm FROM startdbmy.tr_ord t1
WHERE t1.ord_dtm BETWEEN STR_TO_DATE('2021-01-03', '%Y-%m-%d') AND STR_TO_DATE('2021-01-03 23:59:59', '%Y-%m-%d %H:%i:%s')
AND t1.shop_id = 'S001'
ORDER BY t1.ord_no;