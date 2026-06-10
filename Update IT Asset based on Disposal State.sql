DECLARE
    DRCode NVARCHAR2(30);
    DRState NVARCHAR2(30);

BEGIN
    SELECT ctr_code,
           (SELECT prv_value
              FROM r5propertyvalues
             WHERE prv_property = 'IT-DISP'
               AND prv_code = (r5contactrecords.ctr_code || '#IT'))
      INTO DRCode, DRState
      FROM r5contactrecords
     WHERE ROWID = :ROWID;

    IF (DRState = 'Picked Up - PCL Disposal') THEN
        UPDATE r5objects o
           SET o.OBJ_UDFCHAR35 = 'PICKEDUP',
               o.OBJ_UDFCHAR38 = 'DISPOSE'
         WHERE o.obj_udfchar24 = 'CPU'
           AND o.OBJ_CODE IN (
               SELECT d.DESP_ASSETID
                 FROM u5itamdespequip d
                WHERE d.DESP_SRCODE = DRCode
           );
    END IF;

END;
