DROP TABLE ProduitHistory;

CREATE TABLE ProduitHistory (
    u VARCHAR(50),               -- User who performed the operation
    idP NUMBER,                     -- Product ID affected by the operation
    operation_date DATE,            -- Date and time of the operation
    operation_type VARCHAR(20)      -- Type of operation: INSERT, UPDATE, DELETE
);

CREATE OR REPLACE TRIGGER trg_ProduitHistory
AFTER INSERT OR UPDATE OR DELETE ON produit
FOR EACH ROW
DECLARE
BEGIN

    -- For INSERT operation
    IF INSERTING THEN
        INSERT INTO ProduitHistory (u, idP, operation_date, operation_type)
        VALUES (user, :NEW.IDP, SYSDATE, 'INSERT');
    
    -- For UPDATE operation
    ELSIF UPDATING THEN
        INSERT INTO ProduitHistory (u, idP, operation_date, operation_type)
        VALUES (user, :NEW.IDP, SYSDATE, 'UPDATE');
    
    -- For DELETE operation
    ELSIF DELETING THEN
        INSERT INTO ProduitHistory (u, idP, operation_date, operation_type)
        VALUES (user, :OLD.IDP, SYSDATE, 'DELETE');
    END IF;
END;