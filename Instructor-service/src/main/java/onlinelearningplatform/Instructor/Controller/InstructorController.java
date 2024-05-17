package onlinelearningplatform.Instructor.Controller;

import lombok.RequiredArgsConstructor;
import onlinelearningplatform.Instructor.DTO.*;
import onlinelearningplatform.Instructor.Service.InstructorService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/instructor")
public class InstructorController {

    private final InstructorService instructorService;

    @PostMapping("/signup")
    public InstructorResponse instructorSignUp(@RequestBody InstructorRequest instructorRequest) {
        return instructorService.instructorSignUp(instructorRequest);
    }

    @PostMapping("/login")
    public InstructorResponse instructorLogIn(@RequestBody InstructorRequest instructorRequest) {
        return instructorService.instructorLogIn(instructorRequest);
    }

    @PostMapping("/create-course")
    public CourseResponse createCourse(@RequestParam int instructorID, @RequestBody CourseRequest courseRequest) {
        return instructorService.createCourse(instructorID, courseRequest);
    }

    @GetMapping("/search-courses")
    public List<CourseResponse> searchCourses(@RequestParam String key) {
        return instructorService.searchCourses(key);
    }

    @PutMapping("/announce-permission")
    public boolean announcePermission(@RequestParam int courseID, @RequestParam int studentID) {
        return instructorService.announcePermission(courseID, studentID);
    }

    @GetMapping("/accept-permission")
    public boolean acceptPermission(@RequestParam int courseID, @RequestParam int studentID) {
        return instructorService.acceptPermission(courseID, studentID);
    }

    @GetMapping("/reject-permission")
    public boolean rejectPermission(@RequestParam int courseID, @RequestParam int studentID) {
        return instructorService.rejectPermission(courseID, studentID);
    }

    @GetMapping("/get-waiting-list")
    public List<WaitingListResponse> getWaitingList(@RequestParam int instructorID) {
        return instructorService.getWaitingList(instructorID);
    }

    @GetMapping("/get-instructors")
    public List<InstructorResponse> getInstructors() {
        return instructorService.getInstructors();
    }


}
