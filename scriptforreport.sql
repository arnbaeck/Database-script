CREATE TYPE skill_levels as enum('beginner', 'intermediate', 'expert' );

CREATE TABLE "class_room"
(
  "class_room_id" serial PRIMARY KEY,
  "room_number" varchar(100) UNIQUE NOT NULL
);

CREATE TABLE "instrument"
(
  "instrument_id" serial PRIMARY KEY,
  "brand" varchar(100) NOT NULL,
  "name_of_instrument" varchar(100) NOT NULL
);

CREATE TABLE "lesson_price"
(
  "lesson_price_id" serial PRIMARY KEY,
  "price" float(15) NOT NULL,
  "lesson_type" varchar(100)
);

CREATE TABLE "person_at_school"
(
  "person_at_school_id" serial PRIMARY KEY,
  "person_number" varchar(12) UNIQUE NOT NULL,
  "first_name" varchar(100) NOT NULL,
  "last_name" varchar(100) NOT NULL
);

CREATE TABLE "phone_number"
(
  "phone_number" varchar(100) NOT NULL,
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school" ON DELETE CASCADE,
  PRIMARY KEY ("person_at_school_id", "phone_number")
);

CREATE TABLE "schedule"
(
  "scedule_id" serial PRIMARY KEY,
  "date" DATE NOT NULL
);

CREATE TABLE "adress"
(
  "adress" varchar(100) NOT NULL,
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school" ON DELETE CASCADE,
  PRIMARY KEY ("person_at_school_id", "adress")
);

CREATE TABLE "email_adress"
(
  "email_adress" varchar(100) UNIQUE NOT NULL,
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school" ON DELETE CASCADE,
  PRIMARY KEY ("person_at_school_id", "email_adress")
);

CREATE TABLE "instructor"
(
  "instructor_id" serial PRIMARY KEY,
  "employment_id" varchar(100) NOT NULL,
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school"
);

CREATE TABLE "instructor_instrument"
(
  "instrument_id" int NOT NULL REFERENCES "instrument" ON DELETE CASCADE,
  "instructor_id" int NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
  PRIMARY KEY ("instrument_id", "instructor_id")
);

CREATE TABLE "lesson"
(
  "lesson_id" serial PRIMARY KEY,
  "skill_level" skill_levels NOT NULL,
  "is_group" boolean,
  "genere" varchar(100),
  "instructor_id" int NOT NULL REFERENCES "instructor",
  "lesson_price_id" int REFERENCES "lesson_price",
  "schedule_id" int REFERENCES "schedule",
  "class_room_id" int NOT NULL REFERENCES "class_room"
);

CREATE TABLE "lesson_instrument"
(
  "instrument_id" int NOT NULL REFERENCES "instrument" ON DELETE CASCADE,
  "lesson_id" int NOT NULL REFERENCES "lesson" ON DELETE CASCADE,
  PRIMARY KEY ("instrument_id", "lesson_id")
);

CREATE TABLE "owed_to_instructor"
(
  "owed_to_instructor_id" serial PRIMARY KEY,
  "instructor_id" int NOT NULL REFERENCES "instructor",
  "lesson_id" int REFERENCES "lesson",
  "due_date" date NOT NULL
);

CREATE TABLE "parents"
(
  "parents_id" serial PRIMARY KEY,
  "number_of_children" int CHECK(number_of_children >= 0 AND number_of_children <=100),
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school"
);

CREATE TABLE "student"
(
  "student_id" serial PRIMARY KEY,
  "age" int NOT NULL,
  "person_at_school_id" int NOT NULL REFERENCES "person_at_school",
  "parents_id" int REFERENCES "parents" ON DELETE SET NULL
);

CREATE TABLE "student_attending_lesson"
(
  "student_id" int NOT NULL REFERENCES "student" ON DELETE CASCADE,
  "lesson_id" int NOT NULL REFERENCES "lesson" ON DELETE CASCADE,
  PRIMARY KEY ("student_id", "lesson_id")
);

CREATE TABLE "student_instrument"
(
  "student_id" int NOT NULL REFERENCES "student" ON DELETE CASCADE,
  "instrument_id" int NOT NULL REFERENCES "instrument" ON DELETE CASCADE,
  "skill_level" skill_levels NOT NULL,
  PRIMARY KEY ("student_id", "instrument_id")
);

CREATE TABLE "students_allowed"
(
  "lesson_id" int NOT NULL PRIMARY KEY REFERENCES "lesson",
  "min_students_allowed" int NOT NULL,
  "max_students_allowed" int NOT NULL
);

CREATE TABLE "audition"
(
  "audition_id" serial PRIMARY KEY,
  "audition_passed" boolean,
  "instrument_id" int NOT NULL REFERENCES "instrument",
  "student_id" int NOT NULL REFERENCES "student"
);

CREATE TABLE "booking"
(
  "start_time" TIMESTAMP NOT NULL,
  "end_time" TIMESTAMP NOT NULL,
  "schedule_id" int NOT NULL REFERENCES "schedule" ON DELETE CASCADE,
  "class_room_id" int NOT NULL REFERENCES "class_room" ON DELETE CASCADE,
  "lesson_id" int REFERENCES "lesson" ON DELETE CASCADE,
  "audition_id" int REFERENCES "audition",
  PRIMARY KEY ("start_time", "end_time", "schedule_id", "class_room_id")
);

CREATE TABLE "rental_instrument"
(
  "rental_instrument_id" serial PRIMARY KEY,
  "renting fee" float(15) NOT NULL,
  "instrument_id" int NOT NULL REFERENCES "instrument",
  "available" boolean NOT NULL
);

CREATE TABLE "owed_by_student"
(
  "owed_by_student_id" serial PRIMARY KEY,
  "student_id" int NOT NULL REFERENCES "student",
  "lesson_id" int REFERENCES "lesson",
  "rental_instrument_id" int REFERENCES "rental_instrument",
  "due_date" date NOT NULL
);

CREATE TABLE "rentals"
(
  "rentals_id" serial PRIMARY KEY,
  "date_rented" date,
  "leased_until" date,
  "name_of_instrument" varchar(100),
  "student_id" int NOT NULL REFERENCES "student",
  "rental_instrument_id" int NOT NULL REFERENCES "rental_instrument",
  "terminated" boolean
);
