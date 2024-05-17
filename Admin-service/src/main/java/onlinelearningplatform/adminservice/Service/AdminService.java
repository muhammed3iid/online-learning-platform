package onlinelearningplatform.adminservice.Service;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import onlinelearningplatform.adminservice.DTO.CourseRequest;
import onlinelearningplatform.adminservice.DTO.CourseResponse;
import onlinelearningplatform.adminservice.DTO.InstructorResponse;
import onlinelearningplatform.adminservice.DTO.StudentResponse;

import javax.ejb.Stateless;
import java.util.List;

@Stateless
public class AdminService {

    public List<InstructorResponse> getAllInstructors() {
        Client client = ClientBuilder.newClient();
        return client.target("http://localhost:8081/api/instructor/get-instructors").request()
                .get(new GenericType<>() {
                });
    }

    public List<StudentResponse> getAllStudents() {
        Client client = ClientBuilder.newClient();
        return client.target("http://localhost:8082/api/student/get-students").request()
                .get(new GenericType<>() {
                });
    }

    public List<CourseResponse> getAllCourses() {
        Client client = ClientBuilder.newClient();
        return client.target("http://localhost:8080/api/course/search")
                .queryParam("key", "")
                .request()
                .get(new GenericType<>() {
                });
    }

    public boolean editCourse(int courseId, CourseRequest courseRequest) {
        Client client = ClientBuilder.newClient();
        Response response = client.target("http://localhost:8080/api/course/edit")
                .queryParam("courseId", courseId)
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.entity(courseRequest, MediaType.APPLICATION_JSON));

        if (response.getStatus() == Response.Status.OK.getStatusCode()) {
            return true;
        } else {
            System.err.println("Failed to edit course: " + response.getStatus());
            return false;
        }
    }
}
