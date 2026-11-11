-- CROWNFIELD EYE HOSPITAL DATABASE
-- FILE: 06_database_security.sql
-- PURPOSE: Create database roles, assign permissions
-- and demonstrate database access control.

USE crownfield_eye_hospital;


-- Create database security roles.
-- Each role represents a different hospital user type.

CREATE ROLE IF NOT EXISTS
    'hospital_admin',
    'hospital_doctor',
    'hospital_receptionist',
    'hospital_patient';


-- Verify that all four roles exist.

SELECT
    User AS role_name,
    Host AS role_host
FROM mysql.user
WHERE User IN (
    'hospital_admin',
    'hospital_doctor',
    'hospital_receptionist',
    'hospital_patient'
);


-- Grant full database permissions to Admin.
-- Admin can manage all tables in the hospital database.

GRANT ALL PRIVILEGES
ON crownfield_eye_hospital.*
TO 'hospital_admin';


-- Verify Admin permissions.

SHOW GRANTS FOR 'hospital_admin';


-- Grant viewing permissions to Doctor.
-- Doctors can view patient, appointment and clinical information.

GRANT SELECT
ON crownfield_eye_hospital.patient
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.clinician
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.clinic
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.appointment
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.diagnosis
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.appointment_diagnosis
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.prescription
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.medicine
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.prescription_item
TO 'hospital_doctor';

GRANT SELECT
ON crownfield_eye_hospital.follow_up
TO 'hospital_doctor';


-- Allow doctors to manage clinical records.
-- Doctors can add and update diagnoses, prescriptions and follow-ups.

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.diagnosis
TO 'hospital_doctor';

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.appointment_diagnosis
TO 'hospital_doctor';

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.prescription
TO 'hospital_doctor';

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.prescription_item
TO 'hospital_doctor';

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.follow_up
TO 'hospital_doctor';


-- Verify Doctor permissions.

SHOW GRANTS FOR 'hospital_doctor';


-- Grant viewing permissions to Receptionist.
-- Receptionists can view patient and appointment information.

GRANT SELECT
ON crownfield_eye_hospital.patient
TO 'hospital_receptionist';

GRANT SELECT
ON crownfield_eye_hospital.clinician
TO 'hospital_receptionist';

GRANT SELECT
ON crownfield_eye_hospital.clinic
TO 'hospital_receptionist';

GRANT SELECT
ON crownfield_eye_hospital.appointment
TO 'hospital_receptionist';


-- Allow receptionists to manage appointments.
-- Receptionists can create and update appointment records.

GRANT INSERT, UPDATE
ON crownfield_eye_hospital.appointment
TO 'hospital_receptionist';


-- Verify Receptionist permissions.

SHOW GRANTS FOR 'hospital_receptionist';


-- Remove the unrestricted patient view.
-- Patient access will use a restricted stored procedure instead.

DROP VIEW IF EXISTS patient_personal_details;


-- Create a table linking patient accounts
-- to their individual patient records.

CREATE TABLE IF NOT EXISTS patient_user_account
(
    mysql_account VARCHAR(288) PRIMARY KEY,
    patient_id INT NOT NULL UNIQUE,

    CONSTRAINT fk_patient_user_account
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
);


DROP PROCEDURE IF EXISTS GetMyPatientDetails;
-- Create a procedure to retrieve
-- only the logged-in patient's personal details.



DELIMITER //

CREATE PROCEDURE GetMyPatientDetails()
SQL SECURITY DEFINER
BEGIN
    SELECT
        p.patient_id,
        p.patient_number,
        p.first_name,
        p.last_name,
        p.date_of_birth,
        p.email,
        p.phone
    FROM patient p
    INNER JOIN patient_user_account ua
        ON p.patient_id = ua.patient_id
    WHERE ua.mysql_account = USER();
END //

DELIMITER ;


-- Verify that the patient access procedure exists.

SHOW PROCEDURE STATUS
WHERE Db = 'crownfield_eye_hospital'
AND Name = 'GetMyPatientDetails';


-- Create a test account for patient OP001.
-- Replace the example password before creating a new account.

CREATE USER IF NOT EXISTS
    'patient_op001'@'localhost'
IDENTIFIED BY 'Passwor1!@';

-- Link the MySQL account to patient OP001.
-- Prevent duplicate account and patient mappings.

INSERT INTO patient_user_account
(
    mysql_account,
    patient_id
)
SELECT
    'patient_op001@localhost',
    1
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM patient_user_account
    WHERE mysql_account = 'patient_op001@localhost'
)
AND NOT EXISTS (
    SELECT 1
    FROM patient_user_account
    WHERE patient_id = 1
);


-- Allow the Patient role to execute
-- the restricted patient access procedure.

GRANT EXECUTE
ON PROCEDURE crownfield_eye_hospital.GetMyPatientDetails
TO 'hospital_patient';


-- Assign the Patient role to the test account.

GRANT 'hospital_patient'
TO 'patient_op001'@'localhost';


-- Make the Patient role active by default.

SET DEFAULT ROLE 'hospital_patient'
TO 'patient_op001'@'localhost';


-- Verify the patient account mapping.

SELECT *
FROM patient_user_account
WHERE patient_id = 1;


-- Verify Patient role permissions.

SHOW GRANTS FOR 'hospital_patient';


-- Verify permissions assigned to the test account.

SHOW GRANTS FOR 'patient_op001'@'localhost';


-- Configure AES-256 encryption.
-- AES-256-CBC is used to protect sensitive patient contact information.
-- The encryption key is supplied separately for this demonstration.


SET SESSION block_encryption_mode = 'aes-256-cbc';

SET @encryption_key = 'CrownfieldDemoKey2026SecureKey!!';

-- Verify the selected encryption mode.
SELECT @@block_encryption_mode;


-- Create a secure patient contact table.
-- Encrypted email addresses will be stored in this table.
-- The original patient table remains unchanged.
-- The initialisation vector (IV) is stored separately for decryption.

CREATE TABLE IF NOT EXISTS patient_contact_secure
(
    patient_id INT PRIMARY KEY,
    encrypted_email VARBINARY(512) NOT NULL,
    encryption_iv BINARY(16) NOT NULL,

    CONSTRAINT fk_secure_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
);

-- Verify that the secure contact table exists.
DESCRIBE patient_contact_secure;


-- Encrypt patient OP001's email address.
-- AES-256-CBC protects the email address.
-- RANDOM_BYTES generates a random 16-byte initialisation vector.
-- The same IV is used for encryption and stored for later decryption.
-- The original patient table remains unchanged.

INSERT INTO patient_contact_secure
(
    patient_id,
    encrypted_email,
    encryption_iv
)
SELECT
    p.patient_id,
    AES_ENCRYPT(
        p.email,
        'CrownfieldDemoKey2026SecureKey!!',
        r.iv
    ),
    r.iv
FROM patient AS p
CROSS JOIN
(
    SELECT RANDOM_BYTES(16) AS iv
) AS r
WHERE p.patient_number = 'OP001';


-- Verify the encrypted patient contact data.
-- Display the patient ID, encrypted email and IV.
-- The encrypted email should appear as binary data, not readable text.

SELECT
    patient_id,
    HEX(encrypted_email) AS encrypted_email,
    HEX(encryption_iv) AS encryption_iv
FROM patient_contact_secure
WHERE patient_id = 1;

-- Decrypt the patient's email address.
-- AES_DECRYPT uses the same encryption key and IV.
-- This verifies that the original email can be recovered.

SELECT
    patient_id,
    CAST(
        AES_DECRYPT(
            encrypted_email,
            'CrownfieldDemoKey2026SecureKey!!',
            encryption_iv
        ) AS CHAR(255)
    ) AS decrypted_email
FROM patient_contact_secure
WHERE patient_id = 1;

-- Verify the encrypted patient contact record.
-- Confirm that the secure table contains the expected patient record.

SELECT
    COUNT(*) AS encrypted_records
FROM patient_contact_secure;