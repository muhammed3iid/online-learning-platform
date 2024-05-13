package onlinelearningplatform.Courses.Service;

import onlinelearningplatform.Courses.DTO.CourseRequest;
import onlinelearningplatform.Courses.DTO.CourseResponse;
import onlinelearningplatform.Courses.Model.CourseModel;
import onlinelearningplatform.Courses.Repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CourseService {
    private final CourseRepository courseRepository;

    @Autowired
    public CourseService(CourseRepository courseRepository) {
        this.courseRepository = courseRepository;
    }

    public CourseResponse createCourse(CourseRequest courseRequest) {
        if (courseRepository.existsByName(courseRequest.getName())) {
            throw new RuntimeException("User with email " + courseRequest.getName() + " already exists.");
        }
        CourseModel course = courseRepository.save(CourseModel.builder()
                .name(courseRequest.getName())
                .duration(courseRequest.getDuration())
                .category(courseRequest.getCategory())
                .rating(0.0)
                .capacity(courseRequest.getCapacity())
                .numOfEnrolled(0)
                .build()
        );
        return CourseResponse.builder()
                .id(course.getId())
                .name(course.getName())
                .duration(course.getDuration())
                .category(course.getCategory())
                .rating(course.getRating())
                .capacity(course.getCapacity())
                .numOfEnrolled(course.getNumOfEnrolled())
                .build();
    }

    public List<CourseResponse> search(String key) {
        List<CourseModel> courseModelList = new ArrayList<>();
        if (key != null) {
            courseModelList.addAll(courseRepository.findByNameContainingIgnoreCase(key));
            courseModelList.addAll(courseRepository.findByCategoryContainingIgnoreCase(key));
        } else {
            courseModelList.addAll(courseRepository.findAll());
        }
        return courseModelList.stream()
                .map(course -> CourseResponse.builder()
                        .id(course.getId())
                        .name(course.getName())
                        .duration(course.getDuration())
                        .category(course.getCategory())
                        .rating(course.getRating())
                        .capacity(course.getCapacity())
                        .numOfEnrolled(course.getNumOfEnrolled())
                        .build())
                .distinct()
                .collect(Collectors.toList());
    }

    public CourseResponse view(int courseID){
        CourseModel course = courseRepository.findById(courseID);
        return CourseResponse.builder()
                .id(course.getId())
                .name(course.getName())
                .duration(course.getDuration())
                .category(course.getCategory())
                .rating(course.getRating())
                .capacity(course.getCapacity())
                .numOfEnrolled(course.getNumOfEnrolled())
                .build();
    }

    public boolean enroll(int courseID){
        CourseModel course = courseRepository.findById(courseID);
        course.setNumOfEnrolled(course.getNumOfEnrolled()+1);
        return true;
    }

    public boolean cancel(int courseID){
        CourseModel course = courseRepository.findById(courseID);
        course.setNumOfEnrolled(course.getNumOfEnrolled()-1);
        return true;
    }

}
