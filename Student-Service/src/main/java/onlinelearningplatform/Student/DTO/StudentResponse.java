package onlinelearningplatform.Student.DTO;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class StudentResponse {
    private int id;
    String name;
    String email;
    String password;
    String affiliation;
    String bio;
    List<Integer> listOfCoursesID;
}