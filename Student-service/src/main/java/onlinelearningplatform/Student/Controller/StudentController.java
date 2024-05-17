package onlinelearningplatform.Student.Controller;

import lombok.RequiredArgsConstructor;
import onlinelearningplatform.Student.DTO.CourseResponse;
import onlinelearningplatform.Student.DTO.StudentRequest;
import onlinelearningplatform.Student.DTO.StudentResponse;
import onlinelearningplatform.Student.Service.StudentService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/student")
public class StudentController {

    private final StudentService studentService;

    @PostMapping("/signup")
    public StudentResponse studentSignUp(@RequestBody StudentRequest studentRequest) {
        return studentService.studentSignUp(studentRequest);
    }

    @PostMapping("/login")
    public StudentResponse studentLogIn(@RequestBody StudentRequest studentRequest) {
        return studentService.studentLogIn(studentRequest);
    }

    @GetMapping("/get-student")
    public StudentResponse getStudentById(@RequestParam int studentId) {
        return studentService.getStudentById(studentId);
    }

    @GetMapping("/get-students")
    public List<StudentResponse> getStudents() {
        return studentService.getStudents();
    }

    @GetMapping("/search-courses")
    public List<CourseResponse> searchCourses(@RequestParam String key) {
        return studentService.searchCourses(key);
    }

    @GetMapping("/view-enrolled-courses")
    public List<CourseResponse> viewCourses(@RequestParam int studentID) {
        return studentService.viewCourses(studentID);
    }

    @PutMapping("/request")
    public StudentResponse studentRequest(@RequestParam int studentID, @RequestParam int courseID) {
        return studentService.studentRequest(studentID, courseID);
    }

    @PutMapping("/cancel")
    public StudentResponse studentCancel(@RequestParam int studentID, @RequestParam int courseID) {
        return studentService.studentCancel(studentID, courseID);
    }

    @PutMapping("/enroll")
    public Boolean studentEnroll(@RequestParam int studentID, @RequestParam int courseID, @RequestParam String message) {
        return studentService.studentEnroll(studentID, courseID, message);
    }

    @PutMapping("/notify-reject")
    public Boolean studentNotifyReject(@RequestParam int studentId, @RequestParam String message) {
        return studentService.studentNotifyReject(studentId, message);
    }

}
