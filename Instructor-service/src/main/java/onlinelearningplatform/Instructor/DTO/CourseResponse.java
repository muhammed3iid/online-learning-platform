package onlinelearningplatform.Instructor.DTO;

import lombok.Data;

@Data
public class CourseResponse {
    private int id;
    String name;
    String duration;
    String category;
    double rating;
    int capacity;
    int numOfEnrolled;
}
