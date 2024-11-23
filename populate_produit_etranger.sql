DECLARE
    v_count INTEGER;
    CURSOR produit_cursor IS
        SELECT IDP, designation, prixunitaire, IDCategorie
        FROM produit;
BEGIN
    -- First, clear the PRODUIT_Etranger table to ensure it's empty before inserting new data
    DELETE FROM PRODUIT_Etranger;
    
    -- Check if the PRODUIT table is empty
    SELECT count(*) INTO v_count FROM produit;
    IF (v_count = 0) THEN
        -- If PRODUIT table is empty, insert default row
        INSERT INTO PRODUIT_Etranger (IDP, designation, prixunitaire, IDCategorie)
        VALUES (0, 'Pas de produit', NULL, NULL);
    ELSE
        -- Populate PRODUIT_Etranger with data from PRODUIT
        FOR produit IN produit_cursor LOOP
            INSERT INTO PRODUIT_Etranger (IDP, designation, prixunitaire, IDCategorie)
            VALUES (
                produit.IDP,
                UPPER(produit.designation),  -- Convert designation to uppercase
                CASE
                    WHEN produit.prixunitaire IS NULL THEN 0  -- If price is NULL, set to 0
                    ELSE produit.prixunitaire * 0.0058        -- Convert price to Dollars (using example conversion rate)
                END,
                produit.IDCategorie
            );
        END LOOP;
    END IF;

    COMMIT; -- Commit the changes to the database
END;
