package onlinelearningplatform.Courses.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CourseResponse {
    private int id;
    String name;
    String duration;
    String category;
    double rating;
    int capacity;
    int numOfEnrolled;
}
