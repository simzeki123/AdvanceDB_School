CREATE OR REPLACE TRIGGER invalid_update_lang
AFTER UPDATE OR INSERT ON BOOKS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
    languageException EXCEPTION;
BEGIN

    IF (:NEW.language != 'Korean') THEN
        IF (:NEW.language != 'Chinese') THEN
            IF (:NEW.language != 'Malay' ) THEN
                IF(:NEW.language != 'Japanese') THEN
                    IF(:NEW.language != 'English')THEN
                        RAISE languageException;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    EXCEPTION WHEN languageException THEN
    RAISE_APPLICATION_ERROR( -20001, 'The language you have entered is invalid' );

END;
/