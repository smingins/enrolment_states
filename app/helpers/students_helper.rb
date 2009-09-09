module StudentsHelper
  def setup_student(student)
    returning(student) do |s|
      s.build_current_enrolment unless s.current_enrolment
    end
  end
end
