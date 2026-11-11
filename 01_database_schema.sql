
-- CROWNFIELD EYE HOSPITAL DATABASE

-- Create the database if not created already

CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital;

-- Select the database
USE crownfield_eye_hospital;

-- Store patient personal information
CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_number VARCHAR(10) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Store medical specialties
CREATE TABLE specialty (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Store clinician details
-- Each clinician belongs to one specialty
CREATE TABLE clinician (
    clinician_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty_id INT NULL,
    registration_number VARCHAR(30) NOT NULL UNIQUE,
    active_status BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_clinician_specialty
        FOREIGN KEY (specialty_id)
        REFERENCES specialty(specialty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Store hospital clinic locations
CREATE TABLE clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL,
    telephone VARCHAR(20)
);

-- Store patient appointments
-- Each appointment belongs to one patient,
-- one clinician and one clinic.
CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    clinician_id INT NOT NULL,
    clinic_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,

    appointment_status VARCHAR(30)
        NOT NULL DEFAULT 'Booked',

    notes VARCHAR(500),

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointment_clinician
        FOREIGN KEY (clinician_id)
        REFERENCES clinician(clinician_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointment_clinic
        FOREIGN KEY (clinic_id)
        REFERENCES clinic(clinic_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_clinician_appointment
        UNIQUE (clinician_id, appointment_date, appointment_time),

    CONSTRAINT chk_appointment_status
        CHECK (
            appointment_status IN
            ('Booked', 'Completed', 'Cancelled', 'Did Not Attend')
        )
);

-- Store diagnosis information
CREATE TABLE diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_name VARCHAR(150) NOT NULL UNIQUE,
    description VARCHAR(500)
);

-- Connect appointments with diagnoses.
-- This resolves the many-to-many relationship.
CREATE TABLE appointment_diagnosis (
    appointment_id INT NOT NULL,
    diagnosis_id INT NOT NULL,
    diagnosis_date DATE NOT NULL DEFAULT (CURRENT_DATE),

    PRIMARY KEY (appointment_id, diagnosis_id),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (diagnosis_id)
        REFERENCES diagnosis(diagnosis_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- Store prescription information
-- Each prescription belongs to an appointment.
CREATE TABLE prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    prescribed_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    instructions VARCHAR(500),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Store medicine information
CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL UNIQUE,
    description VARCHAR(500)
);


-- Connect prescriptions with medicines.
-- Store dose, route, frequency and duration.
CREATE TABLE prescription_item (
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    route VARCHAR(30) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration_days INT NOT NULL,

    PRIMARY KEY (prescription_id, medicine_id),

    FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_duration
        CHECK (duration_days BETWEEN 1 AND 365),

    CONSTRAINT chk_medicine_route
        CHECK (
            route IN
            ('Ophthalmic', 'Oral', 'Topical', 'Injection')
        )
);

-- Store follow-up plans for appointments.
-- Each appointment can have a maximum of one follow-up plan.
CREATE TABLE follow_up (
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    due_date DATE NOT NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Open',
    notes VARCHAR(500),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_followup_priority
        CHECK (
            priority IN
            ('Low', 'Routine', 'High', 'Urgent')
        ),

    CONSTRAINT chk_followup_status
        CHECK (
            status IN
            ('Open', 'Booked', 'Completed', 'Cancelled')
        )
);

-- Store historical appointment changes.
-- This table preserves audit information independently
-- of the appointment record.
CREATE TABLE appointment_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100),
    
    CONSTRAINT fk_appointment_audit_appointment
	FOREIGN KEY (appointment_id)
	REFERENCES appointment(appointment_id)
      
);




