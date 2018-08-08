class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql,name).flatten
    Student.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT name FROM students where grade = ?"
    DB[:conn].execute(sql,9).flatten
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students where grade != ?"
#    array_of_rows = DB[:conn].execute(sql,12)
#    array_of_rows.each do |row|
#      Student.new_from_db(row)
#      end
      DB[:conn].execute(sql,12)
    end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
