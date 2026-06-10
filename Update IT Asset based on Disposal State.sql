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
  WHERE ROWID = :ROWID AND prv_property = 'IT-DISP';
  
  vPRCode := TRIM(REPLACE(vPRCode,'#IT',''));
  
  SELECT ctr_code
  INTO vSRCode
  FROM r5contactrecords 
  WHERE ctr_code =  vPRCode;
 
	IF vPRValue = 'Picked Up - PCL Disposal' AND vSRType = 'ITDF' AND vSRDispType = 'Disposal' 
  THEN
        UPDATE r5objects o
           SET o.OBJ_UDFCHAR35 = 'PICKEDUP',
               o.OBJ_UDFCHAR38 = 'DISPOSE'
         WHERE o.obj_udfchar24 = 'CPU' AND o.OBJ_CODE IN (
               SELECT d.DESP_ASSETID
                 FROM u5itamdespequip d
                WHERE d.DESP_SRCODE = vSRCode
           );
    END IF;

END;
