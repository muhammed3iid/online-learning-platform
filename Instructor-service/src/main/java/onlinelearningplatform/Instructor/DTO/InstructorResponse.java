package onlinelearningplatform.Instructor.DTO;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class InstructorResponse {
    private int id;
    String name;
    String email;
    String password;
    String affiliation;
    int yearsOfExperience;
    String bio;
    List<Integer> listOfCoursesID;
    Map<Integer, Integer> waitingList;
}
