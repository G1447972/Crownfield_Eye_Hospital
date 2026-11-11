-- CROWNFIELD EYE HOSPITAL DATABASE
-- FILE: 04_procedure_and_triggers.sql
-- PURPOSE: Create the stored procedure and database triggers.

USE crownfield_eye_hospital;


-- Trigger 1: Validate patient date of birth.

DELIMITER //

CREATE TRIGGER trg_check_patient_dob
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    IF NEW.date_of_birth >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date of birth must be in the past.';
    END IF;
END //


-- Trigger 2: Record appointment status changes.

CREATE TRIGGER trg_appointment_status_audit
AFTER UPDATE ON appointment
FOR EACH ROW
BEGIN
    IF OLD.appointment_status <> NEW.appointment_status THEN
        INSERT INTO appointment_audit
        (
            appointment_id,
            old_status,
            new_status,
            changed_by
        )
        VALUES
        (
            NEW.appointment_id,
            OLD.appointment_status,
            NEW.appointment_status,
            USER()
        );
    END IF;
END //


-- Stored procedure: Retrieve follow-ups by priority.

CREATE PROCEDURE GetFollowupsByPriority(IN p_priority VARCHAR(20))
BEGIN
    SELECT
        f.follow_up_id,
        p.patient_number,
        p.first_name,
        p.last_name,
        f.due_date,
        f.priority,
        f.status
    FROM follow_up f
    INNER JOIN appointment a
        ON f.appointment_id = a.appointment_id
    INNER JOIN patient p
        ON a.patient_id = p.patient_id
    WHERE f.priority = p_priority
    ORDER BY f.due_date;
END //

DELIMITER ;