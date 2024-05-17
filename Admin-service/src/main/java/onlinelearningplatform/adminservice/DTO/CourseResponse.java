package onlinelearningplatform.adminservice.DTO;


public class CourseResponse {
    private int id;
    String name;
    String duration;
    String category;
    double rating;
    int capacity;
    int numOfEnrolled;

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

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getNumOfEnrolled() {
        return numOfEnrolled;
    }

    public void setNumOfEnrolled(int numOfEnrolled) {
        this.numOfEnrolled = numOfEnrolled;
    }

}
