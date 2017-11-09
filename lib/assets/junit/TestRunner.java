import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;

public class TestRunner {
   public static void main(String[] args) {
      Result result = JUnitCore.runClasses(JunitTests.class);
      if(result.wasSuccessful()) {
        System.out.println("All tests passed\n");
      } else {
        System.out.prinln("Some tests failed\n");
        System.out.println("Number of failures: " + result.getFailureCount());
        for (Failure failure : result.getFailures()) {
           System.out.println(failure.toString());
        }
      }
   }
}
