package onlinelearningplatform.Courses.Controller;


import lombok.RequiredArgsConstructor;
import onlinelearningplatform.Courses.DTO.CourseRequest;
import onlinelearningplatform.Courses.DTO.CourseResponse;
import onlinelearningplatform.Courses.Service.CourseService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/course")
public class CourseController {

    private final CourseService courseService;

    @PostMapping("/create")
    public CourseResponse createCourse(@RequestBody CourseRequest courseRequest) {
        return courseService.createCourse(courseRequest);
    }

    @GetMapping("/search")
    public List<CourseResponse> searchCourses(@RequestParam String key) {
        return courseService.search(key);
    }

    @GetMapping("/view")
    public CourseResponse viewCourse(@RequestParam int courseID) {
        return courseService.view(courseID);
    }

    @PutMapping("/enroll")
    public CourseResponse enroll(@RequestParam int courseID) {
        return courseService.enroll(courseID);
    }

    @GetMapping("/cancel")
    public boolean cancel(@RequestParam int courseID) {
        return courseService.cancel(courseID);
    }


}
