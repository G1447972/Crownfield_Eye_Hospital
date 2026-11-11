-- Select the database
USE crownfield_eye_hospital;

-- TABLE: SPECIALTY
-- PURPOSE: Store the medical specialties available at Crownfield Eye Hospital.
-- DESCRIPTION: Inserts 10 different ophthalmology specialties with their descriptions.
INSERT INTO specialty (specialty_id, specialty_name, description)
VALUES
(1, 'Glaucoma', 'Diagnosis and treatment of glaucoma.'),
(2, 'Retina', 'Treatment of retinal conditions.'),
(3, 'Cornea', 'Diagnosis and treatment of corneal conditions.'),
(4, 'Cataract', 'Cataract assessment and surgery.'),
(5, 'Paediatric Ophthalmology', 'Eye care for children.'),
(6, 'Oculoplastics', 'Treatment of eyelid and orbital conditions.'),
(7, 'Medical Retina', 'Treatment of medical retinal diseases.'),
(8, 'Neuro-Ophthalmology', 'Diagnosis of eye conditions linked to the nervous system.'),
(9, 'Uveitis', 'Diagnosis and treatment of eye inflammation.'),
(10, 'Emergency Ophthalmology', 'Urgent assessment and treatment of eye conditions.');

-- TABLE: CLINIC
-- PURPOSE: Store information about hospital clinics.
-- DESCRIPTION: Inserts 10 clinic records, including clinic names, locations and telephone numbers.
INSERT INTO clinic (clinic_id, clinic_name, location, telephone)
VALUES
(1, 'City Road Clinic', 'London', '02070000001'),
(2, 'Bedford Clinic', 'Bedford', '01234000002'),
(3, 'Croydon Clinic', 'Croydon', '02080000003'),
(4, 'North Clinic', 'Manchester', '01610000004'),
(5, 'South Clinic', 'Brighton', '01273000005'),
(6, 'East Clinic', 'Norwich', '01603000006'),
(7, 'West Clinic', 'Bristol', '01170000007'),
(8, 'Central Eye Clinic', 'Birmingham', '01210000008'),
(9, 'Riverside Clinic', 'Leeds', '01130000009'),
(10, 'Parkside Clinic', 'Liverpool', '01510000010');


-- TABLE: PATIENT
-- PURPOSE: Store patient personal and contact information.
-- DESCRIPTION: Inserts 10 fictional patient records into the patient table.
-- Each patient is assigned a unique patient number.
INSERT INTO patient
(patient_id, patient_number, first_name, last_name, date_of_birth, postcode, phone, email)
VALUES
(1, 'OP001', 'Amina', 'Yusuf', '1985-04-12', 'E1 6AN', '07111111101', 'amina.yusuf@example.com'),
(2, 'OP002', 'Daniel', 'Reed', '1978-09-23', 'MK40 1AA', '07111111102', 'daniel.reed@example.com'),
(3, 'OP003', 'Sofia', 'Bennett', '1992-02-15', 'CR0 1AA', '07111111103', 'sofia.bennett@example.com'),
(4, 'OP004', 'Michael', 'Okoro', '1969-11-08', 'E1 7AA', '07111111104', 'michael.okoro@example.com'),
(5, 'OP005', 'Emily', 'Carter', '2001-06-19', 'MK41 8AA', '07111111105', 'emily.carter@example.com'),
(6, 'OP006', 'Oliver', 'James', '1990-12-03', 'CR2 6AA', '07111111106', 'oliver.james@example.com'),
(7, 'OP007', 'Fatima', 'Ahmed', '1982-07-27', 'M1 2AB', '07111111107', 'fatima.ahmed@example.com'),
(8, 'OP008', 'George', 'Wilson', '1955-03-14', 'BN1 1AA', '07111111108', 'george.wilson@example.com'),
(9, 'OP009', 'Hannah', 'Clarke', '1996-10-21', 'NR1 3AA', '07111111109', 'hannah.clarke@example.com'),
(10, 'OP010', 'Jacob', 'Morgan', '1973-01-30', 'BS1 4AA', '07111111110', 'jacob.morgan@example.com');


-- TABLE: CLINICIAN
-- PURPOSE: Store information about hospital clinicians.
-- DESCRIPTION: Inserts 10 clinicians and links each clinician to a medical specialty using specialty_id.
INSERT INTO clinician
(clinician_id, first_name, last_name, specialty_id, registration_number, active_status)
VALUES
(1, 'Maya', 'Shah', 1, 'GMC100001', TRUE),
(2, 'Leo', 'Grant', 2, 'GMC100002', TRUE),
(3, 'Priya', 'Nair', 3, 'GMC100003', TRUE),
(4, 'James', 'Taylor', 4, 'GMC100004', TRUE),
(5, 'Sarah', 'Brown', 5, 'GMC100005', TRUE),
(6, 'David', 'Wilson', 6, 'GMC100006', TRUE),
(7, 'Emma', 'Davies', 7, 'GMC100007', TRUE),
(8, 'Robert', 'Evans', 8, 'GMC100008', TRUE),
(9, 'Aisha', 'Khan', 9, 'GMC100009', TRUE),
(10, 'Thomas', 'White', 10, 'GMC100010', TRUE);


-- TABLE: DIAGNOSIS
-- PURPOSE: Store the eye conditions diagnosed at the hospital.
-- DESCRIPTION: Inserts 10 diagnosis records with their names and medical descriptions.
INSERT INTO diagnosis
(diagnosis_id, diagnosis_name, description)
VALUES
(1, 'Ocular hypertension', 'Higher than normal pressure inside the eye.'),
(2, 'Diabetic macular oedema', 'Fluid accumulation in the macula associated with diabetes.'),
(3, 'Glaucoma suspect', 'Signs that may indicate possible glaucoma.'),
(4, 'Keratoconus', 'A condition causing the cornea to become thin and irregular.'),
(5, 'Cataract', 'Clouding of the natural lens of the eye.'),
(6, 'Dry eye syndrome', 'Insufficient lubrication of the eye surface.'),
(7, 'Retinal detachment', 'Separation of the retina from supporting tissue.'),
(8, 'Uveitis', 'Inflammation inside the eye.'),
(9, 'Conjunctivitis', 'Inflammation of the conjunctiva.'),
(10, 'Age-related macular degeneration', 'A condition affecting central vision.');


-- Insert 10 appointment records
-- Each appointment is linked to an existing patient,
-- clinician and clinic using their ID numbers.
INSERT INTO appointment
(
    appointment_id,
    patient_id,
    clinician_id,
    clinic_id,
    appointment_date,
    appointment_time,
    appointment_status,
    notes
)
VALUES

-- Appointment 1: Amina visits Dr Maya Shah at City Road Clinic
(1, 1, 1, 1, '2026-10-20', '09:00:00',
 'Completed', 'Routine eye pressure check.'),

-- Appointment 2: Daniel visits Dr Leo Grant at Bedford Clinic
(2, 2, 2, 2, '2026-10-21', '10:00:00',
 'Completed', 'Retinal assessment.'),

-- Appointment 3: Sofia visits Dr Priya Nair at Croydon Clinic
(3, 3, 3, 3, '2026-10-22', '11:00:00',
 'Completed', 'Corneal examination.'),

-- Appointment 4: Michael visits Dr Maya Shah at City Road Clinic
(4, 4, 1, 1, '2026-10-23', '12:00:00',
 'Completed', 'Glaucoma review.'),

-- Appointment 5: Emily has a booked cataract consultation
(5, 5, 4, 4, '2026-11-02', '09:30:00',
 'Booked', 'Cataract consultation.'),

-- Appointment 6: Oliver has a booked paediatric eye assessment
(6, 6, 5, 5, '2026-11-03', '10:30:00',
 'Booked', 'Paediatric eye assessment.'),

-- Appointment 7: Fatima has a booked eyelid assessment
(7, 7, 6, 6, '2026-11-04', '11:30:00',
 'Booked', 'Eyelid assessment.'),

-- Appointment 8: George has a booked medical retina review
(8, 8, 7, 7, '2026-11-05', '13:00:00',
 'Booked', 'Medical retina review.'),

-- Appointment 9: Hannah's appointment has been cancelled
(9, 9, 8, 8, '2026-11-06', '14:00:00',
 'Cancelled', 'Neuro-ophthalmology consultation.'),

-- Appointment 10: Jacob has a booked urgent eye assessment
(10, 10, 10, 9, '2026-11-07', '15:00:00',
 'Booked', 'Urgent eye assessment.');
 
 
-- TABLE: APPOINTMENT_DIAGNOSIS
-- PURPOSE: Link patient appointments to their recorded diagnoses.
-- DESCRIPTION: Inserts 10 diagnosis records associated with existing appointments.

INSERT INTO appointment_diagnosis
(appointment_id, diagnosis_id, diagnosis_date)
VALUES
(1, 1, '2026-10-20'),
(2, 2, '2026-10-21'),
(3, 4, '2026-10-22'),
(4, 3, '2026-10-23'),
(5, 5, '2026-11-02'),
(6, 6, '2026-11-03'),
(7, 8, '2026-11-04'),
(8, 10, '2026-11-05'),
(9, 9, '2026-11-06'),
(10, 7, '2026-11-07');


-- TABLE: MEDICINE
-- PURPOSE: Store medicines available for hospital prescriptions.
-- DESCRIPTION: Inserts 10 medicines with their names and descriptions.
INSERT INTO medicine
(medicine_id, medicine_name, description)
VALUES
(1, 'Latanoprost', 'Eye drops used to reduce intraocular pressure.'),
(2, 'Timolol', 'Eye drops used to reduce pressure inside the eye.'),
(3, 'Aflibercept', 'Medicine used to treat certain retinal conditions.'),
(4, 'Sodium chloride drops', 'Eye drops used for eye lubrication.'),
(5, 'Artificial tears', 'Lubricating eye drops for dry eyes.'),
(6, 'Dexamethasone', 'Medicine used to treat eye inflammation.'),
(7, 'Chloramphenicol', 'Antibiotic used for certain eye infections.'),
(8, 'Cyclopentolate', 'Eye drops used to dilate the pupil.'),
(9, 'Brimonidine', 'Eye drops used to reduce intraocular pressure.'),
(10, 'Dorzolamide', 'Eye drops used to reduce eye pressure.');


-- TABLE: PRESCRIPTION
-- PURPOSE: Store prescriptions issued during patient appointments.
-- DESCRIPTION: Inserts 10 prescriptions linked to existing appointments.
INSERT INTO prescription
(prescription_id, appointment_id, prescribed_date, instructions)
VALUES
(1, 1, '2026-10-20', 'Use eye drops once daily.'),
(2, 2, '2026-10-21', 'Use medication as directed by the clinician.'),
(3, 3, '2026-10-22', 'Apply prescribed eye drops as instructed.'),
(4, 4, '2026-10-23', 'Use eye drops twice daily.'),
(5, 5, '2026-11-02', 'Follow the clinician prescription instructions.'),
(6, 6, '2026-11-03', 'Use lubricating eye drops when required.'),
(7, 7, '2026-11-04', 'Apply medication according to instructions.'),
(8, 8, '2026-11-05', 'Attend the scheduled retinal treatment review.'),
(9, 9, '2026-11-06', 'Follow the prescribed treatment instructions.'),
(10, 10, '2026-11-07', 'Use medication as directed by the clinician.');


-- TABLE: PRESCRIPTION_ITEM
-- PURPOSE: Store the medicines included in each prescription.
-- DESCRIPTION: Inserts 10 prescription items linked to existing prescriptions and medicines.
INSERT INTO prescription_item
(prescription_id, medicine_id, dosage, route, frequency, duration_days)
VALUES
(1, 1, '1 drop', 'Ophthalmic', 'Once daily', 30),
(2, 3, '2 mg', 'Injection', 'As prescribed', 30),
(3, 4, '1 drop', 'Ophthalmic', 'Three times daily', 14),
(4, 2, '1 drop', 'Ophthalmic', 'Twice daily', 30),
(5, 5, '1 drop', 'Ophthalmic', 'As required', 14),
(6, 6, '1 drop', 'Ophthalmic', 'Twice daily', 7),
(7, 7, '1 drop', 'Ophthalmic', 'Four times daily', 7),
(8, 9, '1 drop', 'Ophthalmic', 'Twice daily', 30),
(9, 8, '1 drop', 'Ophthalmic', 'As prescribed', 5),
(10, 10, '1 drop', 'Ophthalmic', 'Twice daily', 30);


-- TABLE: FOLLOW_UP
-- PURPOSE: Store patient follow-up appointment information.
-- DESCRIPTION: Inserts 10 follow-up records with due dates, priorities, statuses and notes.
INSERT INTO follow_up
(follow_up_id, appointment_id, due_date, priority, status, notes)
VALUES
(1, 1, '2026-11-20', 'Routine', 'Open', 'Review eye pressure.'),
(2, 2, '2026-11-21', 'High', 'Open', 'Review retinal condition.'),
(3, 3, '2026-11-22', 'Routine', 'Booked', 'Check corneal condition.'),
(4, 4, '2026-11-23', 'High', 'Open', 'Monitor glaucoma symptoms.'),
(5, 5, '2026-12-02', 'Routine', 'Open', 'Review cataract assessment.'),
(6, 6, '2026-12-03', 'Low', 'Open', 'Review eye health.'),
(7, 7, '2026-12-04', 'Routine', 'Booked', 'Review eyelid condition.'),
(8, 8, '2026-12-05', 'Urgent', 'Open', 'Review retinal treatment.'),
(9, 9, '2026-12-06', 'High', 'Open', 'Arrange further assessment.'),
(10, 10, '2026-12-07', 'Urgent', 'Open', 'Urgent eye condition review.');