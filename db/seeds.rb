Course.delete_all
Assignment.delete_all
Submission.delete_all


Course.create(course_code:12, course_title:"Advanced Programming Techniques")
Course.create(course_code:21, course_title:"Data Structures and Algorithms")
Course.create(course_code:166, course_title:"Capstone: Software Engineering")

Assignment.create(course_id: 1, instructions: "Write Fib", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))
Assignment.create(course_id: 2, instructions: "Write Fib-iter", template: "public class Solution {\n\t\n}", due_date: Time.now.strftime("%d/%m/%Y %H:%M"))