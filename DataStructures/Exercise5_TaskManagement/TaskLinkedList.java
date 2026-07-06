
public class TaskLinkedList {

    private static class Node {
        Task task;
        Node next;

        Node(Task task) {
            this.task = task;
            this.next = null;
        }
    }

    private Node head;
    private int size;

    public TaskLinkedList() {
        head = null;
        size = 0;
    }

    // Add a task at the head - O(1)
    public void addTask(Task task) {
        Node newNode = new Node(task);
        newNode.next = head;
        head = newNode;
        size++;
        System.out.println("Added: " + task);
    }

    // Search by taskId - O(n)
    public Task search(int taskId) {
        Node current = head;
        while (current != null) {
            if (current.task.getTaskId() == taskId) {
                return current.task;
            }
            current = current.next;
        }
        return null;
    }

    // Traverse and print all tasks - O(n)
    public void traverse() {
        Node current = head;
        while (current != null) {
            System.out.println(current.task);
            current = current.next;
        }
    }

    // Delete by taskId - O(n)
    public boolean delete(int taskId) {
        if (head == null) return false;

        if (head.task.getTaskId() == taskId) {
            System.out.println("Deleting: " + head.task);
            head = head.next;
            size--;
            return true;
        }

        Node prev = head;
        Node current = head.next;
        while (current != null) {
            if (current.task.getTaskId() == taskId) {
                System.out.println("Deleting: " + current.task);
                prev.next = current.next;
                size--;
                return true;
            }
            prev = current;
            current = current.next;
        }
        return false;
    }

    public static void main(String[] args) {
        TaskLinkedList list = new TaskLinkedList();

        list.addTask(new Task(1, "Design schema", "Pending"));
        list.addTask(new Task(2, "Implement API", "In Progress"));
        list.addTask(new Task(3, "Write tests", "Pending"));

        System.out.println("\n--- Traverse ---");
        list.traverse();

        System.out.println("\n--- Search id=2 ---");
        Task found = list.search(2);
        System.out.println(found != null ? "Found: " + found : "Not found");

        System.out.println("\n--- Delete id=1 ---");
        list.delete(1);

        System.out.println("\n--- Traverse after delete ---");
        list.traverse();
    }
}
