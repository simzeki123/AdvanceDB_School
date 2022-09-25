CREATE OR REPLACE TRIGGER invalid_update
AFTER UPDATE OR INSERT ON BOOKS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

DECLARE
    categoriesException EXCEPTION;


BEGIN
    IF (:NEW.categories != 'Science Fiction') THEN
        IF (:NEW.categories != 'Horror') THEN
            IF (:NEW.categories != 'Romance' ) THEN
                IF(:NEW.categories != 'Fantasy') THEN
                    IF(:NEW.categories != 'History')THEN
                        RAISE categoriesException;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;



    EXCEPTION WHEN categoriesException THEN
    RAISE_APPLICATION_ERROR( -20001, 
                             'The catogory you have entered is invalid' );
END;
/