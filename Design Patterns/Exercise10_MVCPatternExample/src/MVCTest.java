public class MVCTest {
    public static void main(String[] args) {
        // Create model
        Student student = new Student("John Doe", "S1001", "A");

        // Create view
        StudentView view = new StudentView();

        // Create controller, linking model and view
        StudentController controller = new StudentController(student, view);

        controller.updateView();

        // Update student details via controller
        controller.setStudentName("Jane Doe");
        controller.setStudentGrade("A+");

        controller.updateView();
    }
}
