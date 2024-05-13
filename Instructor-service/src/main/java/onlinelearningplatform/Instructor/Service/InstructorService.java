package onlinelearningplatform.Instructor.Service;

import onlinelearningplatform.Instructor.DTO.CourseRequest;
import onlinelearningplatform.Instructor.DTO.CourseResponse;
import onlinelearningplatform.Instructor.DTO.InstructorRequest;
import onlinelearningplatform.Instructor.DTO.InstructorResponse;
import onlinelearningplatform.Instructor.Model.InstructorModel;
import onlinelearningplatform.Instructor.Repository.InstructorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

@Service
@Transactional
public class InstructorService {
    private final InstructorRepository instructorRepository;

    @Autowired
    public InstructorService(InstructorRepository instructorRepository) {
        this.instructorRepository = instructorRepository;
    }

    public InstructorResponse instructorSignUp(InstructorRequest instructorRequest) {
        if (instructorRepository.existsByEmail(instructorRequest.getEmail())) {
            throw new RuntimeException("User with email " + instructorRequest.getEmail() + " already exists.");
        }
        InstructorModel instructor = instructorRepository.save(InstructorModel.builder()
                .name(instructorRequest.getName())
                .email(instructorRequest.getEmail())
                .password(instructorRequest.getPassword())
                .affiliation(instructorRequest.getAffiliation())
                .yearsOfExperience(instructorRequest.getYearsOfExperience())
                .bio(instructorRequest.getBio())
                .listOfCoursesID(new ArrayList<>())
                .waitingList(new HashMap<>())
                .build()
        );
        return InstructorResponse.builder()
                .id(instructor.getId())
                .name(instructor.getName())
                .email(instructor.getEmail())
                .password(instructor.getPassword())
                .affiliation(instructor.getAffiliation())
                .yearsOfExperience(instructor.getYearsOfExperience())
                .bio(instructor.getBio())
                .listOfCoursesID(instructor.getListOfCoursesID())
                .waitingList(instructor.getWaitingList())
                .build();
    }

    public InstructorResponse instructorLogIn(InstructorRequest instructorRequest) {
        InstructorModel instructor = instructorRepository.findByEmail(instructorRequest.getEmail());
        if (instructor == null) {
            throw new RuntimeException("User with email " + instructorRequest.getEmail() + " not found.");
        }
        if (!instructor.getPassword().equals(instructorRequest.getPassword())) {
            throw new RuntimeException("Incorrect password.");
        }
        return InstructorResponse.builder()
                .id(instructor.getId())
                .name(instructor.getName())
                .email(instructor.getEmail())
                .password(instructor.getPassword())
                .affiliation(instructor.getAffiliation())
                .yearsOfExperience(instructor.getYearsOfExperience())
                .bio(instructor.getBio())
                .listOfCoursesID(instructor.getListOfCoursesID())
                .waitingList(instructor.getWaitingList())
                .build();
    }

    public CourseResponse createCourse(int instructorID, CourseRequest courseRequest) {
        InstructorModel instructor = instructorRepository.findById(instructorID);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<CourseRequest> request = new HttpEntity<>(courseRequest, headers);
        ResponseEntity<CourseResponse> responseEntity =
                new RestTemplate().postForEntity(
                        "http://localhost:8080/api/course/create", request, CourseResponse.class);
        instructor.getListOfCoursesID().add(Objects.requireNonNull(responseEntity.getBody()).getId());
        return responseEntity.getBody();
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

    public boolean announcePermission(int courseID, int studentID) {
        InstructorModel instructor = instructorRepository.findByListOfCoursesIDContains(courseID);
        instructor.getWaitingList().put(courseID, studentID);
        return true;
    }

}
