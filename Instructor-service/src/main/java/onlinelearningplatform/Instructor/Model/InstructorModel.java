package onlinelearningplatform.Instructor.Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.Map;

@Entity
@Table(name = "instructors")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InstructorModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    String name;

    String email;

    String password;

    String affiliation;

    int yearsOfExperience;

    String bio;

    @ElementCollection
    @Column(name = "course_id")
    List<Integer> listOfCoursesID;

    @ElementCollection
    @CollectionTable(name = "waiting_list", joinColumns = @JoinColumn(name = "instructor_id"))
    @MapKeyColumn(name = "course_id")
    @Column(name = "student_id")
    Map<Integer, Integer> waitingList;

}
