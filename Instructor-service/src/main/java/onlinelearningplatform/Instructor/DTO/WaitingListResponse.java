package onlinelearningplatform.Instructor.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WaitingListResponse {
    int studentId;
    int courseId;
    String studentName;
    String courseName;
}
