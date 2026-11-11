-- CROWNFIELD EYE HOSPITAL DATABASE
-- FILE: 05_student3_queries.sql
-- PURPOSE: Six individual SQL queries for Student 3.

USE crownfield_eye_hospital;


-- Q1: Count open follow-ups by priority.

SELECT
    priority,
    COUNT(*) AS total_open_followups
FROM follow_up
WHERE status = 'Open'
GROUP BY priority
HAVING COUNT(*) >= 2
ORDER BY total_open_followups DESC;


-- Q2: Display patient appointments, clinicians and follow-up details.

SELECT
    p.patient_number,
    p.first_name,
    p.last_name,
    a.appointment_date,
    c.first_name AS clinician_first_name,
    c.last_name AS clinician_last_name,
    f.due_date,
    f.priority,
    f.status AS follow_up_status
FROM patient p
INNER JOIN appointment a
    ON p.patient_id = a.patient_id
INNER JOIN clinician c
    ON a.clinician_id = c.clinician_id
INNER JOIN follow_up f
    ON a.appointment_id = f.appointment_id
ORDER BY a.appointment_date;


-- Q3: Find appointments without follow-up records.

SELECT
    a.appointment_id,
    p.patient_number,
    p.first_name,
    p.last_name,
    a.appointment_date,
    f.follow_up_id,
    f.due_date,
    f.status AS follow_up_status
FROM appointment a
INNER JOIN patient p
    ON a.patient_id = p.patient_id
LEFT JOIN follow_up f
    ON a.appointment_id = f.appointment_id
WHERE f.follow_up_id IS NULL;

ROLLBACK;



-- Q4: Find follow-ups due sooner than the average waiting period.

SELECT
    f.follow_up_id,
    f.appointment_id,
    f.due_date,
    DATEDIFF(f.due_date, a.appointment_date) AS waiting_days
FROM follow_up f
INNER JOIN appointment a
    ON f.appointment_id = a.appointment_id
WHERE DATEDIFF(f.due_date, a.appointment_date) < (
    SELECT AVG(DATEDIFF(f2.due_date, a2.appointment_date))
    FROM follow_up f2
    INNER JOIN appointment a2
        ON f2.appointment_id = a2.appointment_id
)
ORDER BY waiting_days;


-- Q5: Retrieve high-priority follow-ups using the stored procedure.

CALL GetFollowupsByPriority('High');


-- Q6: Test the appointment status audit trigger.

START TRANSACTION;

UPDATE appointment
SET appointment_status = 'Completed'
WHERE appointment_id = 10
AND appointment_status = 'Booked';

SELECT *
FROM appointment_audit
WHERE appointment_id = 10;

ROLLBACK;