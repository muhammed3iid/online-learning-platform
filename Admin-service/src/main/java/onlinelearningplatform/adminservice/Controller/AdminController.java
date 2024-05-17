package onlinelearningplatform.adminservice.Controller;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import onlinelearningplatform.adminservice.DTO.CourseRequest;
import onlinelearningplatform.adminservice.DTO.CourseResponse;
import onlinelearningplatform.adminservice.DTO.InstructorResponse;
import onlinelearningplatform.adminservice.DTO.StudentResponse;
import onlinelearningplatform.adminservice.Service.AdminService;

import java.util.List;

@Path("/admin")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class AdminController {
    @Inject
    private AdminService adminService;

    @GET
    @Path("/view-instructors")
    public List<InstructorResponse> getAllInstructors(){
        return adminService.getAllInstructors();
    }

    @GET
    @Path("/view-students")
    public List<StudentResponse> getAllStudents(){
        return adminService.getAllStudents();
    }

    @GET
    @Path("/view-courses")
    public List<CourseResponse> getAllCourses(){
        return adminService.getAllCourses();
    }

    @PUT
    @Path("/edit-course")
    public boolean editCourse(@QueryParam("courseId") int courseId, CourseRequest courseRequest){
        return adminService.editCourse(courseId, courseRequest);
    }

}
