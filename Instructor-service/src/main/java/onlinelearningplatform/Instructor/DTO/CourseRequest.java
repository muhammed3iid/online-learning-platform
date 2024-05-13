package onlinelearningplatform.Instructor.DTO;

import lombok.Data;

@Data
public class CourseRequest {
    String name;
    String duration;
    String category;
    int capacity;
}
