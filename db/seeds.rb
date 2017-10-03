Student.delete_all
Student.reset_pk_sequence
Teacher.delete_all
Teacher.reset_pk_sequence
Course.delete_all
Course.reset_pk_sequence
Assignment.delete_all
Assignment.reset_pk_sequence
Submission.delete_all
Submission.reset_pk_sequence

Student.create(name: 'John Doe', email: 'johndoe1@brandeis.edu', password: '123456', password_confirmation: '123456')
Student.create(name: 'Jane Doe', email: 'janedoe@brandeis.edu', password: '123456', password_confirmation: '123456')
Student.create(name: 'Foo Bar', email: 'foobar@brandeis.edu', password: '123456', password_confirmation: '123456')
Student.create(name: 'Bar Foo', email: 'barfoo@brandeis.edu', password: '123456', password_confirmation: '123456')

Teacher.create(name: 'Pito Salas', email: 'rpsalas@brandeis.edu', password: '123456', password_confirmation: '123456')
Teacher.create(name: 'Antonella', email: 'antonella@brandeis.edu', password: '123456', password_confirmation: '123456')
Teacher.create(name: 'Tim Hickey', email: 'tjhickey@brandeis.edu', password: '123456', password_confirmation: '123456')

Course.create(course_code:11, course_title:"Intro to Programming", teacher_id: 3)
Course.create(course_code:12, course_title:"Advanced Programming Techniques", teacher_id: 1)
Course.create(course_code:21, course_title:"Data Structures and Algorithms", teacher_id: 2)
Course.create(course_code:166, course_title:"Capstone: Software Engineering", teacher_id: 1)

Assignment.create(course_id: 1, instructions: "Write Fib", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))
Assignment.create(course_id: 2, instructions: "Write Fib-iter", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))
Assignment.create(course_id: 3, instructions: "Print even #", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))

Submission.create(student_id: 3, assignment_id: 1, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 100)
Submission.create(student_id: 3, assignment_id: 2, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 80)
Submission.create(student_id: 2, assignment_id: 1, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 90)