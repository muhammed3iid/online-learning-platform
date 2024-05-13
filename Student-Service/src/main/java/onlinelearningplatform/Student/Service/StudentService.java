package onlinelearningplatform.Student.Service;

import onlinelearningplatform.Student.DTO.CourseResponse;
import onlinelearningplatform.Student.DTO.StudentRequest;
import onlinelearningplatform.Student.DTO.StudentResponse;
import onlinelearningplatform.Student.Model.StudentModel;
import onlinelearningplatform.Student.Repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class StudentService {
    private final StudentRepository studentRepository;

    @Autowired
    public StudentService(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    public StudentResponse studentSignUp(StudentRequest studentRequest) {
        if (studentRepository.existsByEmail(studentRequest.getEmail())) {
            throw new RuntimeException("User with email " + studentRequest.getEmail() + " already exists.");
        }
        StudentModel student = studentRepository.save(StudentModel.builder()
                .name(studentRequest.getName())
                .email(studentRequest.getEmail())
                .password(studentRequest.getPassword())
                .affiliation(studentRequest.getAffiliation())
                .bio(studentRequest.getBio())
                .listOfCoursesID(new ArrayList<>())
                .build()
        );
        return StudentResponse.builder()
                .id(student.getId())
                .name(student.getName())
                .email(student.getEmail())
                .password(student.getPassword())
                .affiliation(student.getAffiliation())
                .bio(student.getBio())
                .listOfCoursesID(student.getListOfCoursesID())
                .build();
    }

    public StudentResponse studentLogIn(StudentRequest studentRequest) {
        StudentModel student = studentRepository.findByEmail(studentRequest.getEmail());
        if (student == null) {
            throw new RuntimeException("User with email " + studentRequest.getEmail() + " not found.");
        }
        if (!student.getPassword().equals(studentRequest.getPassword())) {
            throw new RuntimeException("Incorrect password.");
        }
        return StudentResponse.builder()
                .id(student.getId())
                .name(student.getName())
                .email(student.getEmail())
                .password(student.getPassword())
                .affiliation(student.getAffiliation())
                .bio(student.getBio())
                .listOfCoursesID(student.getListOfCoursesID())
                .build();
    }

    public List<CourseResponse> searchCourses(String key) {
        RestTemplate restTemplate = new RestTemplate();
        String url = "http://localhost:8080/api/course/search";
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("key", key);
        ResponseEntity<List<CourseResponse>> responseEntity = restTemplate.exchange(
                builder.toUriString(), HttpMethod.GET, null,
                new ParameterizedTypeReference<>() {
                });
        return responseEntity.getBody();
    }

    public List<CourseResponse> viewCourses(int studentID) {
        StudentModel student = studentRepository.findById(studentID);
        List<CourseResponse> courseResponseList = new ArrayList<>();
        for (int id : student.getListOfCoursesID()) {
            RestTemplate restTemplate = new RestTemplate();
            String url = "http://localhost:8080/api/course/view";
            UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
                    .queryParam("courseID", id);
            ResponseEntity<CourseResponse> responseEntity = restTemplate.exchange(
                    builder.toUriString(), HttpMethod.GET, null,
                    new ParameterizedTypeReference<>() {
                    });
            courseResponseList.add(responseEntity.getBody());
        }
        return courseResponseList;
    }

    public StudentResponse studentEnroll(int studentID, int courseID) {
        StudentModel student = studentRepository.findById(studentID);
        RestTemplate restTemplate = new RestTemplate();
        String url = "http://localhost:8081/api/instructor/announce-permission";
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("courseID", courseID)
                .queryParam("studentID", studentID);
        restTemplate.exchange(
                builder.toUriString(), HttpMethod.PUT, null,
                new ParameterizedTypeReference<>() {
                });
        return StudentResponse.builder()
                .id(student.getId())
                .name(student.getName())
                .email(student.getEmail())
                .password(student.getPassword())
                .affiliation(student.getAffiliation())
                .bio(student.getBio())
                .listOfCoursesID(student.getListOfCoursesID())
                .build();
    }

    public StudentResponse studentCancel(int studentID, int courseID) {
        StudentModel student = studentRepository.findById(studentID);
        RestTemplate restTemplate = new RestTemplate();
        String url = "http://localhost:8080/api/course/cancel";
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("courseID", courseID);
        ResponseEntity<Boolean> responseEntity = restTemplate.exchange(
                builder.toUriString(), HttpMethod.GET, null,
                new ParameterizedTypeReference<>() {
                });
        if (Boolean.TRUE.equals(responseEntity.getBody())) {
            student.getListOfCoursesID().remove(courseID);
        }
        return StudentResponse.builder()
                .id(student.getId())
                .name(student.getName())
                .email(student.getEmail())
                .password(student.getPassword())
                .affiliation(student.getAffiliation())
                .bio(student.getBio())
                .listOfCoursesID(student.getListOfCoursesID())
                .build();
    }

}