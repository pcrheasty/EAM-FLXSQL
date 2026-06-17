SELECT :1||COALESCE(
  (SELECT MIN(num) + 1 
   FROM (SELECT to_number(regexp_replace(USTA_CODE, '[^0-9]', '')) as num
         FROM U5ITAMSTATIONS
         WHERE USTA_CODE LIKE :1||'%') t1
   WHERE NOT EXISTS (SELECT 1 FROM U5ITAMSTATIONS 
                     WHERE to_number(regexp_replace(USTA_CODE, '[^0-9]', '')) = t1.num + 1
                     AND USTA_CODE LIKE :1||'%')
   AND EXISTS (SELECT 1 FROM U5ITAMSTATIONS 
               WHERE to_number(regexp_replace(USTA_CODE, '[^0-9]', '')) = t1.num
               AND USTA_CODE LIKE :1||'%')),
  (SELECT MAX(to_number(regexp_replace(USTA_CODE, '[^0-9]', ''))) + 1
   FROM U5ITAMSTATIONS
   WHERE USTA_CODE LIKE :1||'%')
)
FROM dual