DECLARE
  CURSOR cyclist_cursor IS
    SELECT r.idcycliste
    FROM resultat r
    GROUP BY r.idcycliste
    HAVING COUNT(DISTINCT r.idetape) = (SELECT COUNT(*) FROM etape);
  v_totalTemps NUMBER;
BEGIN
  -- Cursor to loop through each cyclist who has participated in all stages
  FOR cyclist IN cyclist_cursor LOOP
    -- Calculate total time for the current cyclist
    SELECT SUM(r.temps)
    INTO v_totalTemps
    FROM resultat r
    WHERE r.idcycliste = cyclist.idcycliste;

    -- Insert into the ResultatFinal table
    INSERT INTO resultatfinal (idcycliste, totaltemps)
    VALUES (cyclist.idcycliste, v_totalTemps);
  END LOOP;

  -- Commit the transaction
  COMMIT;
END;