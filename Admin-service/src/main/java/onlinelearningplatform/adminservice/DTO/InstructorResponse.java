package onlinelearningplatform.adminservice.DTO;

import java.util.List;
import java.util.Map;

public class InstructorResponse {
    private int id;
    private String name;
    private String email;
    private String password;
    private String affiliation;
    private int yearsOfExperience;
    private String bio;
    private List<Integer> listOfCoursesID;
    private Map<Integer, Integer> waitingList;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAffiliation() {
        return affiliation;
    }

    public void setAffiliation(String affiliation) {
        this.affiliation = affiliation;
    }

    public int getYearsOfExperience() {
        return yearsOfExperience;
    }

    public void setYearsOfExperience(int yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public List<Integer> getListOfCoursesID() {
        return listOfCoursesID;
    }

    public void setListOfCoursesID(List<Integer> listOfCoursesID) {
        this.listOfCoursesID = listOfCoursesID;
    }

    public Map<Integer, Integer> getWaitingList() {
        return waitingList;
    }

    public void setWaitingList(Map<Integer, Integer> waitingList) {
        this.waitingList = waitingList;
    }
}
