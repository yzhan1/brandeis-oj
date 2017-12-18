User.delete_all
User.reset_pk_sequence
Course.delete_all
Course.reset_pk_sequence
Assignment.delete_all
Assignment.reset_pk_sequence
Submission.delete_all
Submission.reset_pk_sequence
Enrollment.delete_all
Enrollment.reset_pk_sequence
Announcement.delete_all
Announcement.reset_pk_sequence
Code.delete_all
Code.reset_pk_sequence

User.create(name: 'Frank Diaz', email: 'frank@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Matthew Rogers', email: 'matt@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Ryan Lee', email: 'ryan@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Johnny Lopez', email: 'johnny@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Aaron Griffin', email: 'aaron@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Mark Garcia', email: 'mark@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Ernest Russell', email: 'ernest@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Rose Henderson', email: 'rose@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Stephen Jenkins', email: 'stephen@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Julie Young', email: 'julie@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Peter Long', email: 'peter@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Kathy Simmons', email: 'kathy@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Evelyn Kelly', email: 'evelyn@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Tina Cox', email: 'tina@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Juan Peterson', email: 'juan@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Kathleen Cook', email: 'kath@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Alice Williams', email: 'alice@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Thomas Brooks', email: 'thomas@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Lillian James', email: 'lillian@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Alan Scott', email: 'alan@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')
User.create(name: 'Albert Washington', email: 'albert@brandeis.edu', password: '123456', password_confirmation: '123456', role: 'student')

Course.create(course_code:"180a", course_title:"Algorithms", permission: SecureRandom.hex(10))

Enrollment.create(user_id:1, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:2, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:3, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:4, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:5, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:6, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:7, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:8, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:9, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:10, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:11, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:12, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:13, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:14, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:15, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:16, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:17, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:18, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:19, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:20, course_id:1, grade: 0.0, total: 0.0, count: 0.0)
Enrollment.create(user_id:21, course_id:1, grade: 0.0, total: 0.0, count: 0.0)

Assignment.create(lang: "java", name: "Fibonacci Algorithm", course_id: 1, instructions: "Write Fib", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))

Submission.create(user_id: 4, assignment_id: 3, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 100)
# Submission.create(user_id: 3, assignment_id: 2, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 80)
Submission.create(user_id: 2, assignment_id: 1, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 90)
Submission.create(user_id: 1, assignment_id: 1, source_code: "public class Solution {\n\treturn null;\n}", submission_date: Time.now.strftime("%d/%m/%Y %H:%M"), grade: 90)