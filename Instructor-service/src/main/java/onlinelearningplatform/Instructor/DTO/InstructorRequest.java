package onlinelearningplatform.Instructor.DTO;

import lombok.Data;

@Data
public class InstructorRequest {
    String name;
    String email;
    String password;
    String affiliation;
    int yearsOfExperience;
    String bio;
}
