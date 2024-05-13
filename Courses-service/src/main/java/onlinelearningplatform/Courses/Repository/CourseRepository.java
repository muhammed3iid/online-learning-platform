package onlinelearningplatform.Courses.Repository;

import onlinelearningplatform.Courses.Model.CourseModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CourseRepository extends JpaRepository<CourseModel, Integer> {
    boolean existsByName(String name);

    List<CourseModel> findByNameContainingIgnoreCase(String name);

    List<CourseModel> findByCategoryContainingIgnoreCase(String category);

    CourseModel findById(int id);

}