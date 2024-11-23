CREATE OR REPLACE TRIGGER check_nbCycliste
BEFORE INSERT OR UPDATE OR DELETE ON cycliste
FOR EACH ROW
DECLARE
  v_nbCycliste NUMBER;
BEGIN
  -- Get the current number of cyclists in the team
  SELECT nbCycliste
  INTO v_nbCycliste
  FROM equipe
  WHERE idequipe = :NEW.idequipe;

  -- Adjust the number of cyclists depending on the operation (insert, update, delete)
  IF INSERTING OR UPDATING THEN
    v_nbCycliste := v_nbCycliste + 1; -- New cyclist added or an existing one updated
  ELSIF DELETING THEN
    v_nbCycliste := v_nbCycliste - 1; -- Cyclist is being deleted
  END IF;

  -- Check if the number of cyclists is between 4 and 6
  IF v_nbCycliste < 4 OR v_nbCycliste > 6 THEN
    RAISE_APPLICATION_ERROR(-20001, 'The number of cyclists per team must be between 4 and 6.');
  END IF;

  -- Update the nbCycliste field in the equipe table after insert or update
  IF INSERTING OR UPDATING THEN
    UPDATE equipe
    SET nbCycliste = v_nbCycliste
    WHERE idequipe = :NEW.idequipe;
  END IF;

  COMMIT;
END;
