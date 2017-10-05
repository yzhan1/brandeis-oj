#IGNORE WHAT'S DOWN HERE, TESTING PURPOSES
#--James Wang
ProdCourse.delete_all
ProdCourse.reset_pk_sequence
ProdStudent.delete_all
ProdStudent.reset_pk_sequence
ProdEnrollment.delete_all
ProdEnrollment.reset_pk_sequence

ProdCourse.create(course_code:11, course_title:"Intro to Programming")
ProdCourse.create(course_code:12, course_title:"Advanced Programming Techniques")
ProdCourse.create(course_code:166, course_title:"Capstone: Software Engineering")

ProdStudent.create(id:1, name: 'John Doe', email: 'johndoe1@brandeis.edu', password: '123456', password_confirmation: '123456')
ProdStudent.create(id:2, name: 'Jane Doe', email: 'janedoe@brandeis.edu', password: '123456', password_confirmation: '123456')

ProdEnrollment.create(student_id:1, course_id:11)
ProdEnrollment.create(student_id:1, course_id:12)
ProdEnrollment.create(student_id:1, course_id:166)
ProdEnrollment.create(student_id:2, course_id:11)
