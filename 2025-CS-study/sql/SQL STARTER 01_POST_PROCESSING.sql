

-- 업로드후 일부 데이터 NULL로 변경
UPDATE startdbmy.ms_shop
SET    shop_end_ymd = NULL
WHERE  shop_end_ymd = '';

-- 관계 제약 생성
ALTER TABLE startdbmy.tr_event_entry    ADD CONSTRAINT tr_event_entry_fk01   FOREIGN KEY (event_id)   REFERENCES ms_event(event_id);
ALTER TABLE startdbmy.tr_event_entry    ADD CONSTRAINT tr_event_entry_fk02   FOREIGN KEY (mbr_id)     REFERENCES ms_mbr(mbr_id);
ALTER TABLE startdbmy.tr_event_entry    ADD CONSTRAINT tr_event_entry_fk03   FOREIGN KEY (shop_id)    REFERENCES ms_shop(shop_id);
ALTER TABLE startdbmy.cm_base_cd        ADD CONSTRAINT cm_base_cd_fk01       FOREIGN KEY (base_cd_dv) REFERENCES cm_base_cd_dv(base_cd_dv);
ALTER TABLE startdbmy.ms_item           ADD CONSTRAINT ms_item_fk01          FOREIGN KEY (item_cat)   REFERENCES ms_item_cat(item_cat);
ALTER TABLE startdbmy.ms_item_prc_hist  ADD CONSTRAINT ms_item_prc_hist_fk01 FOREIGN KEY (item_id)    REFERENCES ms_item(item_id);
ALTER TABLE startdbmy.tr_ord            ADD CONSTRAINT tr_ord_fk01           FOREIGN KEY (mbr_id)     REFERENCES ms_mbr(mbr_id);
ALTER TABLE startdbmy.tr_ord            ADD CONSTRAINT tr_ord_fk02           FOREIGN KEY (shop_id)    REFERENCES ms_shop(shop_id);
ALTER TABLE startdbmy.tr_ord_det        ADD CONSTRAINT tr_ord_det_fk01       FOREIGN KEY (ord_no)     REFERENCES tr_ord(ord_no);
ALTER TABLE startdbmy.tr_ord_det        ADD CONSTRAINT tr_ord_det_fk02       FOREIGN KEY (item_id)    REFERENCES ms_item(item_id);

CREATE INDEX tr_ord_x01 ON startdbmy.tr_ord(ord_dtm);

-- 통계 생성
ANALYZE TABLE startdbmy.cm_base_cd;
ANALYZE TABLE startdbmy.cm_base_cd_dv;
ANALYZE TABLE startdbmy.cm_base_dt;
ANALYZE TABLE startdbmy.ms_event;
ANALYZE TABLE startdbmy.ms_item;
ANALYZE TABLE startdbmy.ms_item_cat;
ANALYZE TABLE startdbmy.ms_item_prc_hist;
ANALYZE TABLE startdbmy.ms_mbr;
ANALYZE TABLE startdbmy.ms_shop;
ANALYZE TABLE startdbmy.tr_event_entry;
ANALYZE TABLE startdbmy.tr_ord;
ANALYZE TABLE startdbmy.tr_ord_det;