import buddy.reporting.ConsoleFileReporter;
import buddy.SuitesRunner;

class TestMain {
	public static function main() {
		var reporter = new buddy.reporting.ConsoleFileReporter(true);
		var runner = new buddy.SuitesRunner([
            new shapes.TestCircle(),
            new twod.TestGJK2D()
		], reporter);

		runner.run();
	}
}