DECLARE
  vSRCode      VARCHAR2(30);
  vSRType      VARCHAR2(30);
  vSRDispType  VARCHAR2(30);
  vPRCode      VARCHAR2(30);
  vPRProperty  VARCHAR2(30);
  vPRValue     VARCHAR2(80);

BEGIN
  SELECT prv_code, prv_property, prv_value
  INTO vPRCode, vPRProperty, vPRValue
  FROM r5propertyvalues
  WHERE ROWID = :ROWID;

	IF vPRCode LIKE '%#IT'
	   AND vPRValue = 'Picked Up - PCL Disposal'
	THEN
      BEGIN
        SELECT ctr_code
        INTO vSRCode
        FROM r5contactrecords
        WHERE ctr_code||'#IT' = vPRCode;

        UPDATE r5objects o
           SET o.OBJ_UDFCHAR35 = 'PICKEDUP',
               o.OBJ_UDFCHAR38 = CASE
                                   WHEN o.obj_udfchar24 = 'CPU' THEN 'DISPOSE'
                                   ELSE o.OBJ_UDFCHAR38
                                 END
         WHERE o.OBJ_CODE IN (
               SELECT d.DESP_ASSETID
                 FROM u5itamdespequip d
                WHERE d.DESP_SRCODE = vSRCode
           );
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; 
        WHEN OTHERS THEN
          RAISE;
      END;
	END IF;

END;
