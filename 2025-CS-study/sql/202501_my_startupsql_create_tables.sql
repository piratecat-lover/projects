-- use mysql;
-- DROP DATABASE startdbmy;

-- CREATE DATABASE startdbmy;

USE startdbmy;

CREATE TABLE startdbmy.cm_base_cd_dv
(
    base_cd_dv             VARCHAR(40)  NOT NULL COMMENT '기준코드구분',
    base_cd_dv_nm          VARCHAR(100) NULL     COMMENT '기준코드구분명',
    PRIMARY KEY (base_cd_dv)
) COMMENT '기준코드구분';


CREATE TABLE startdbmy.cm_base_cd
(
    base_cd_dv             VARCHAR(40)  NOT NULL COMMENT '기준코드구분',
    base_cd                VARCHAR(40)  NOT NULL COMMENT '기준코드',
    base_cd_nm             VARCHAR(100) NULL     COMMENT '기준코드명',
    sort_seq               INTEGER      NULL     COMMENT '정렬순서',
    PRIMARY KEY(base_cd_dv,base_cd)
) COMMENT '기준코드';


CREATE TABLE startdbmy.ms_item_cat
(
    item_cat              VARCHAR(40)  NOT NULL COMMENT '상품카테고리',
    item_cat_nm           VARCHAR(100) NULL     COMMENT '상품카테고리명',
    PRIMARY KEY(item_cat)
) COMMENT '상품카테고리';



CREATE TABLE startdbmy.ms_item
(
    item_id               VARCHAR(40)  NOT NULL COMMENT '상품ID',
    item_nm               VARCHAR(100) NULL     COMMENT '상품명',
    item_cat              VARCHAR(40)  NULL     COMMENT '상품카테고리',
    item_size_cd          VARCHAR(40)  NULL     COMMENT '상품사이즈코드',
    hot_cold_cd           VARCHAR(40)  NULL     COMMENT '아이스/HOT구분코드',
    lach_dt               DATE         NULL     COMMENT '출시일자',
    PRIMARY KEY(item_id)
) COMMENT '상품';


CREATE TABLE startdbmy.ms_item_prc_hist
(
    item_id               VARCHAR(40)   NOT NULL COMMENT '상품ID',
    prc_start_dt          DATE          NOT NULL COMMENT '가격시작일자',
    prc_end_dt            DATE          NULL     COMMENT '가격종료일자',
    sale_prc              DECIMAL(18,3) NULL     COMMENT '판매가격',
    PRIMARY KEY (item_id,prc_start_dt)
) COMMENT '상품가격이력';

CREATE TABLE startdbmy.ms_shop
(
    shop_id               VARCHAR(40)  NOT NULL COMMENT '매장ID',
    shop_nm               VARCHAR(100) NULL     COMMENT '매장명',
    shop_size             INTEGER      NULL     COMMENT '매장면적(미터제곱)',
    shop_oper_tp          VARCHAR(40)  NULL     COMMENT '매장운영유형(직영,대리점,플래그십)',
    table_qty             INTEGER      NULL     COMMENT '테이블수',
    chair_qty             INTEGER      NULL     COMMENT '의자수',
    open_time             VARCHAR(100) NULL     COMMENT '오픈시간',
    close_time            VARCHAR(100) NULL     COMMENT '클로즈시간',
    shop_st               VARCHAR(40)  NULL     COMMENT '매장상태',
    shop_start_ymd        VARCHAR(8)   NULL     COMMENT '매장시작일자',
    shop_end_ymd          VARCHAR(8)   NULL     COMMENT '매장종료일자',
    PRIMARY KEY(shop_id)
) COMMENT '매장';


CREATE TABLE startdbmy.ms_mbr
(
    mbr_id             VARCHAR(40)  NOT NULL COMMENT '회원ID',
    nick_nm            VARCHAR(100) NULL     COMMENT '닉네임',
    mobl_no            VARCHAR(100) NULL     COMMENT '핸드폰번호',
    emal_adr           VARCHAR(100) NULL     COMMENT '이메일',
    join_dtm           DATETIME     NULL     COMMENT '가입일시',
    join_tp            VARCHAR(40)  NULL     COMMENT '가입유형',
    mbr_gd             VARCHAR(40)  NULL     COMMENT '회원등급',
    mbr_st             VARCHAR(40)  NULL     COMMENT '회원상태',
    leave_dtm          DATETIME     NULL     COMMENT '탈퇴일시',
    PRIMARY KEY (mbr_id)
) COMMENT '회원';


CREATE TABLE startdbmy.tr_ord
(
    ord_no              BIGINT UNSIGNED NOT NULL COMMENT '주문번호',
    ord_dtm             DATETIME        NULL     COMMENT '주문일시',
    prep_cmp_dtm        DATETIME        NULL     COMMENT '제조완료일시',
    pkup_dtm            DATETIME        NULL     COMMENT '픽업일시',
    mbr_id              VARCHAR(40)     NULL     COMMENT '회원ID',
    shop_id             VARCHAR(40)     NULL     COMMENT '매장ID',
    ord_st              VARCHAR(40)     NULL     COMMENT '주문상태',
    ord_amt             DECIMAL(18,3)   NULL     COMMENT '주문금액',
    pay_tp              VARCHAR(40)     NULL     COMMENT '지불유형',
    PRIMARY KEY(ord_no)
) COMMENT '주문';


CREATE TABLE startdbmy.tr_ord_det
(
    ord_no              BIGINT UNSIGNED NOT NULL COMMENT '주문번호',
    ord_det_no          INTEGER         NOT NULL COMMENT '주문상세번호',
    item_id             VARCHAR(40)     NULL     COMMENT '상품ID',
    ord_qty             INTEGER         NULL     COMMENT '주문수량',
    sale_prc            DECIMAL(18,3)   NULL     COMMENT '판매가격',
    PRIMARY KEY (ord_no,ord_det_no)
) COMMENT '주문상세';


CREATE TABLE startdbmy.cm_base_dt
(   base_dt       DATE         NOT NULL COMMENT '기준일자'
    ,base_ymd     VARCHAR(8)   NULL     COMMENT '기준일자_YMD'
    ,base_dt_seq  INT          NULL     COMMENT '기준일자순번'
    ,base_wkd     VARCHAR(10)  NULL     COMMENT '기준요일'
    ,PRIMARY KEY(base_dt)
) COMMENT '기준일자';



CREATE TABLE startdbmy.ms_event
(   event_id          VARCHAR(40)  NOT NULL COMMENT '이벤트ID'
    ,event_nm         VARCHAR(100) NULL     COMMENT '이벤트명'
    ,event_start_dtm  DATETIME     NULL     COMMENT '이벤트시작일시'
    ,event_end_dtm    DATETIME     NULL     COMMENT '이벤트종료일시'
    ,PRIMARY KEY(event_id)
) COMMENT '이벤트';


CREATE TABLE startdbmy.tr_event_entry
(    event_id         VARCHAR(40)   NOT NULL COMMENT '이벤트ID'
    ,entry_no         INTEGER       NOT NULL COMMENT '응모순번'
    ,shop_id          VARCHAR(40)   NULL     COMMENT '매장ID'
    ,mbr_id           VARCHAR(40)   NULL     COMMENT '회원ID'
    ,entry_dtm        DATETIME      NULL     COMMENT '응모일시'
    ,entry_rslt_cd    VARCHAR(40)   NULL     COMMENT '응모결과코드'
    ,entry_rslt_dtm   DATETIME      NULL     COMMENT '응모결과일시'
    ,PRIMARY KEY(event_id,entry_no)
) COMMENT '이벤트';

