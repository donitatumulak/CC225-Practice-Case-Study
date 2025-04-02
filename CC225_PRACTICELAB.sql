-- CREATE DATABASE university_accomodation_office_db;
-- Use the database
-- USE university_accomodation_office_db;

-- Students table
CREATE TABLE students (
    matric_num INT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10),
    birth_date DATE NOT NULL,
    sex VARCHAR(10) NOT NULL CHECK (sex IN ('Female', 'Male')),
    category VARCHAR(15) NOT NULL CHECK (category IN ('Undergraduate', 'Postgraduate')),
    nationality VARCHAR(30),
    smoker VARCHAR(3) NOT NULL CHECK (smoker IN ('Yes', 'No')),
    special_needs VARCHAR(50),
    comments TEXT,
    current_status VARCHAR(10) NOT NULL CHECK (current_status IN ('Placed', 'Waiting')),
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE
);

-- Advisor of Studies table
CREATE TABLE advisor_of_studies (
    advisor_ID INT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    department_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    room_number INT NOT NULL
);

-- Halls of Residence table
CREATE TABLE halls_of_residence (
    hall_ID VARCHAR(15) PRIMARY KEY,
    hall_name VARCHAR(50) NOT NULL, 
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10),
    telephone_number VARCHAR(15) NOT NULL UNIQUE,
    hall_manager VARCHAR(50) NOT NULL
);

-- Hall Rooms table
CREATE TABLE hall_rooms (
    hall_place_number VARCHAR(10) PRIMARY KEY,
    room_number INT NOT NULL,
    hall_ID VARCHAR(15) NOT NULL,
    monthly_rent DECIMAL(10, 2) NOT NULL, 	
    FOREIGN KEY (hall_ID) REFERENCES halls_of_residence(hall_ID)
);

-- Student Flats table 
CREATE TABLE student_flats (
    flat_number VARCHAR(15) PRIMARY KEY,
    street VARCHAR(50) NOT NULL,          
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10),
    available_room INT NOT NULL
);

-- Student Flat Rooms table
CREATE TABLE student_flat_rooms (
    flat_place_number VARCHAR(10) PRIMARY KEY,
    room_number INT NOT NULL,
    flat_number VARCHAR(15) NOT NULL,
    monthly_rent DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (flat_number) REFERENCES student_flats(flat_number)
);

-- Leases table (corrected FKs)
CREATE TABLE leases (
    lease_ID INT PRIMARY KEY,
    lease_sem_duration VARCHAR(20) NOT NULL CHECK (lease_sem_duration IN ('First Semester', 'Second Semester', 'Summer Semester', 'Full Year')),
    matric_number INT NOT NULL,
    hall_place_number VARCHAR(10),  
    flat_place_number VARCHAR(10),  
    room_number INT NOT NULL,
    room_type VARCHAR(10) NOT NULL CHECK (room_type IN ('Hall', 'Flat')),
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10),
    date_to_start DATE NOT NULL,
    date_to_leave DATE,
    approval_date DATE NOT NULL,
    
    FOREIGN KEY (matric_number) REFERENCES students(matric_num),
    FOREIGN KEY (hall_place_number) REFERENCES hall_rooms(hall_place_number),
    FOREIGN KEY (flat_place_number) REFERENCES student_flat_rooms(flat_place_number),
    CHECK (
        (hall_place_number IS NOT NULL AND flat_place_number IS NULL) OR
        (hall_place_number IS NULL AND flat_place_number IS NOT NULL)
    )
);

-- Invoices table
CREATE TABLE invoices (
	invoice_ID INT PRIMARY KEY,
    lease_ID INT NOT NULL,
    semester VARCHAR(20) NOT NULL CHECK (semester IN ('First Semester', 'Second Semester', 'Summer Semester')),
    payment_due DECIMAL(10, 2) NOT NULL,
    issuance_date DATE NOT NULL,
    FOREIGN KEY (lease_ID) REFERENCES leases(lease_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Invoice Payment table
CREATE TABLE invoice_payment (
	payment_ID INT PRIMARY KEY,
    invoice_ID INT NOT NULL,  
    payment_method VARCHAR(10) NOT NULL CHECK (payment_method IN ('Cash', 'Cheque', 'E-bank', 'Others')) DEFAULT 'Others',
    first_reminder DATE NOT NULL,
    second_reminder DATE,
    payment_date DATE NOT NULL,
    FOREIGN KEY (invoice_ID) REFERENCES invoices(invoice_ID)
);

-- Staff Accommodation table
CREATE TABLE staff_accommodation (  
    staff_ID INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10),
    birth_date DATE NOT NULL,
    sex VARCHAR(10) NOT NULL CHECK (sex IN ('Male', 'Female')),
    staff_position VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(50) UNIQUE
);

-- Flat Inspections table
CREATE TABLE flat_inspections (
    inspection_ID INT PRIMARY KEY,
    staff_ID INT NOT NULL,  
    inspection_date DATE NOT NULL,
    indicated_satisfactory_condition VARCHAR(3) NOT NULL CHECK (indicated_satisfactory_condition IN ('Yes', 'No')),  
    comments TEXT,
    FOREIGN KEY (staff_ID) REFERENCES staff_accommodation(staff_ID)
);

-- Program Course table
CREATE TABLE program_course (
    program_number INT PRIMARY KEY,
    program_title_year VARCHAR(50) NOT NULL, 
    program_chairman VARCHAR(50) NOT NULL, 
    phone_number VARCHAR(15) NOT NULL UNIQUE,  
    room_number INT NOT NULL, 
    department_name VARCHAR(30) NOT NULL
);

-- Student Emergency Contact table
CREATE TABLE student_emergency_contact (
    matric_num INT NOT NULL,
    contact_person VARCHAR(50) NOT NULL,
    relationship VARCHAR(20) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL, 
    postcode VARCHAR(10),
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    FOREIGN KEY (matric_num) REFERENCES students(matric_num)
);

-- DATA POPULATION
INSERT INTO students (matric_num, firstname, lastname, street, city, postcode, birth_date, sex, category, nationality, smoker, special_needs, comments, current_status, phone_number, email)
VALUES 
(1001, 'Alice', 'Johnson', '123 Maple St', 'Cebu City', '6000', '2000-05-15', 'Female', 'Undergraduate', 'Filipino', 'No', NULL, 'Excellent student', 'Placed', '09123456789', 'alice.johnson@email.com'),
(1002, 'Brian', 'Smith', '456 Pine Rd', 'Cebu City', '6000', '1999-10-22', 'Male', 'Postgraduate', 'American', 'Yes', 'Hearing Impairment', 'Needs interpreter', 'Waiting', '09223344556', 'brian.smith@email.com'),
(1003, 'Carla', 'Reyes', '789 Oak Ave', 'Mandaue', '6014', '2001-03-09', 'Female', 'Undergraduate', 'Filipino', 'No', NULL, 'Active in sports', 'Placed', '09334455667', 'carla.reyes@email.com');

INSERT INTO advisor_of_studies (advisor_ID, firstname, lastname, department_name, phone_number, email, room_number)
VALUES
(1, 'Dr. Mark', 'Gonzalez', 'Computer Science', '09111222333', 'mark.gonzalez@uni.com', 101),
(2, 'Prof. Anna', 'Lee', 'Business Admin', '09233445566', 'anna.lee@uni.com', 202);

INSERT INTO halls_of_residence (hall_ID, hall_name, street, city, postcode, telephone_number, hall_manager)
VALUES
('H001', 'Sunrise Hall', '100 Main St', 'Cebu City', '6000', '032-5551234', 'Mr. Lorenzo Cruz'),
('H002', 'Moonlight Hall', '200 South Rd', 'Mandaue', '6014', '032-5555678', 'Ms. Bella Santos');

INSERT INTO hall_rooms (hall_place_number, room_number, hall_ID, monthly_rent)
VALUES
('HR001', 101, 'H001', 4500.00),
('HR002', 102, 'H001', 4700.00),
('HR003', 201, 'H002', 4900.00);

INSERT INTO student_flats (flat_number, street, city, postcode, available_room)
VALUES
('F001', '321 North St', 'Cebu City', '6000', 3),
('F002', '654 West Ave', 'Mandaue', '6014', 2);

INSERT INTO student_flat_rooms (flat_place_number, room_number, flat_number, monthly_rent)
VALUES
('FR001', 1, 'F001', 5200.00),
('FR002', 2, 'F001', 5400.00),
('FR003', 1, 'F002', 5000.00);

INSERT INTO leases (lease_ID, lease_sem_duration, matric_number, hall_place_number, flat_place_number, room_number, room_type, street, city, postcode, date_to_start, date_to_leave, approval_date)
VALUES
(1, 'First Semester', 1001, 'HR001', NULL, 101, 'Hall', '123 Maple St', 'Cebu City', '6000', '2025-06-01', '2025-12-31', '2025-05-20'),
(2, 'Full Year', 1002, NULL, 'FR001', 1, 'Flat', '321 North St', 'Cebu City', '6000', '2025-01-15', '2025-12-31', '2025-01-10'),
(3, 'Second Semester', 1003, 'HR002', NULL, 201, 'Hall', '200 South Rd', 'Mandaue', '6014', '2025-08-01', '2026-01-31', '2025-07-20');

INSERT INTO invoices (invoice_ID, lease_ID, semester, payment_due, issuance_date)
VALUES
(1, 1, 'First Semester', 27000.00, '2025-06-10'),
(2, 2, 'Summer Semester', 62400.00, '2025-01-15'),
(3, 3, 'Second Semester', 29400.00, '2025-08-10');

INSERT INTO invoice_payment (payment_ID, invoice_ID, payment_method, first_reminder, second_reminder, payment_date)
VALUES
(1, 1, 'E-bank', '2025-06-15', NULL, '2025-06-20'),
(2, 2, 'Cash', '2025-02-01', '2025-02-15', '2025-02-20'),
(3, 3, 'Cheque', '2025-09-01', NULL, '2025-09-05');

INSERT INTO staff_accommodation (staff_ID, first_name, last_name, street, city, postcode, birth_date, sex, staff_position, location, phone_number, email)
VALUES
(1, 'Luis', 'Martinez', '789 Elm St', 'Cebu City', '6000', '1985-04-10', 'Male', 'Maintenance', 'Sunrise Hall', '09998887766', 'luis.martinez@uni.com'),
(2, 'Maria', 'Fernandez', '456 Pine Rd', 'Mandaue', '6014', '1990-09-25', 'Female', 'Security', 'Moonlight Hall', '09887766554', 'maria.fernandez@uni.com');

INSERT INTO flat_inspections (inspection_ID, staff_ID, inspection_date, indicated_satisfactory_condition, comments)
VALUES
(1, 1, '2025-03-10', 'Yes', 'No issues found'),
(2, 2, '2025-04-12', 'No', 'Minor repairs needed');

INSERT INTO program_course (program_number, program_title_year, program_chairman, phone_number, room_number, department_name)
VALUES
(1, 'BS Information Systems 2025', 'Dr. Mark Gonzales', '0911223344', 105, 'Computer Science'),
(2, 'BS Business Admin 2025', 'Prof. Anna Lee', '0922334455', 205, 'Business Admin');

INSERT INTO student_emergency_contact (matric_num, contact_person, relationship, street, city, postcode, phone_number)
VALUES
(1001, 'Emma Johnson', 'Mother', '123 Maple St', 'Cebu City', '6000', '09175556677'),
(1002, 'John Smith', 'Father', '456 Pine Rd', 'Cebu City', '6000', '09228889900'),
(1003, 'Laura Reyes', 'Sister', '789 Oak Ave', 'Mandaue', '6014', '09339991122');
students

