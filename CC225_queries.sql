-- SAMPLE QUERIES
-- a)	Present a report listing the manager’s name and telephone number for each hall of residence.
USE university_accomodation_office_db;
SELECT hall_ID, hall_manager, telephone_number
FROM halls_of_residence;

SELECT 
    s.matric_num, 
    s.firstname, 
    s.lastname, 
    l.lease_sem_duration, 
    l.room_number, 
    l.room_type, 
    l.street, 
    l.city, 
    l.postcode, 
    l.date_to_start, 
    l.date_to_leave
FROM students s, leases l
WHERE s.matric_num = l.matric_number;

-- c)	Display the details of lease agreements that include the Summer Semester.
SELECT *
FROM leases
WHERE lease_sem_duration = "Summer Semester";

-- d)	Display the details of the total rent paid by a given student.
SELECT 
    s.matric_num, 
    s.firstname, 
    s.lastname, 
	(h.monthly_rent * 5) AS total_rent
FROM students s
JOIN leases l ON s.matric_num = l.matric_number
JOIN hall_rooms h ON l.room_number = h.room_number
WHERE s.matric_num = '1001';  -- Replace with actual matric number

-- e)	Present a report on students who have not paid their invoices by a given date.
SELECT s.matric_num, s.firstname, s.lastname, i.is_paid
FROM invoices i
JOIN leases l ON l.lease_ID = i.lease_ID
JOIN students s ON s.matric_num = l.matric_number
WHERE i.is_paid = 'No';

-- f)	Display the details of flat inspections where the property was found to be in an unsatisfactory condition.
SELECT *
FROM flat_inspections
WHERE indicated_satisfactory_condition = 'No';

-- g)	Present a report of the names and matriculation numbers of students with their room number and place number in a particular hall of residence.
SELECT 
    s.matric_num, 
    s.firstname, 
    s.lastname, 
    hr.room_number, 
    hr.hall_place_number 
FROM students s
JOIN leases l ON s.matric_num = l.matric_number
JOIN hall_rooms hr ON hr.room_number = l.room_number;

-- h)	Present a report listing the details of all students currently on the waiting list for accommodation, that, not placed.
SELECT *
FROM students
WHERE current_status = 'Waiting';

-- i)	Display the total number of students in each student category.
SELECT category, count(*) AS total_number
FROM students
GROUP BY category;

SELECT s.matric_num, s.firstname, s.lastname, se.contact_person
FROM students s
LEFT JOIN student_emergency_contact se
    ON s.matric_num = se.matric_num
WHERE se.contact_person IS NULL;

-- k)	Display the name and internal telephone number of the Advisor of Studies for a particular student.
SELECT s.matric_num, a.firstname, a.lastname, a.phone_number
FROM advisor_of_studies a
JOIN students s ON a.advisor_ID = s.advisor_ID
WHERE s.matric_num = '1004';

-- l)	Display the minimum, maximum, and average monthly rent for rooms in halls of residence.
SELECT MIN(monthly_rent) AS minimum_rent, MAX(monthly_rent) AS maximum_rent, AVG(monthly_rent/3) AS average_rent
FROM hall_rooms;

-- m)	Display the total number of places in each hall of residence.
SELECT COUNT(hall_place_number) AS total_number_places
FROM hall_rooms;

-- n)	Display the staff number, name, age, and current location of all members of the accommodation staff who are over 60 years old today.
SELECT staff_ID, first_name, last_name, 
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age, 
       location
FROM staff_accommodation
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 30;

