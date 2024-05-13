package onlinelearningplatform.Student.Repository;

import onlinelearningplatform.Student.Model.StudentModel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<StudentModel, Integer> {
    boolean existsByEmail(String email);

    StudentModel findByEmail(String email);

    StudentModel findById(int id);
}
