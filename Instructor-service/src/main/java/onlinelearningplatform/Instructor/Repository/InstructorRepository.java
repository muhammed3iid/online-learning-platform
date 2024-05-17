package onlinelearningplatform.Instructor.Repository;

import onlinelearningplatform.Instructor.Model.InstructorModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface InstructorRepository extends JpaRepository<InstructorModel, Integer> {
    boolean existsByEmail(String email);

    InstructorModel findByEmail(String email);

    InstructorModel findById(int Id);

    InstructorModel findByListOfCoursesIDContains(int Id);

}