package onlinelearningplatform.Student.Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "students")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    String name;

    String email;

    String password;

    String affiliation;

    String bio;

    @ElementCollection
    @Column(name = "course_id")
    List<Integer> listOfCoursesID;
}
