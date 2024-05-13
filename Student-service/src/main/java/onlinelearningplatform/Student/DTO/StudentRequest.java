package onlinelearningplatform.Student.DTO;

import lombok.Data;

@Data
public class StudentRequest {
    String name;
    String email;
    String password;
    String affiliation;
    String bio;
}