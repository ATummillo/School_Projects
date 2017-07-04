import org.scalautils._
import TripleEquals._
import Tolerance._

class RunningVar() extends java.io.Serializable {
	var variance = 0.toDouble
	var sum_x = 0.toDouble
	var sum_x_sqr = 0.toDouble
	var n = 0

	def this(numbers: Iterator[Double]) = {
		this()
		numbers.foreach(this.add(_))
	}

	//Update Variance for a single value
	def add(value: Double) = {
		sum_x_sqr += (value*value)
		sum_x += value
		n += 1
		variance = (sum_x_sqr/n) - ((sum_x/n)*(sum_x/n))
	}

	//Merge another RunningVar object and update variance
	def merge(other: RunningVar): RunningVar = {
		sum_x_sqr += other.sum_x_sqr
		sum_x += other.sum_x
		n += other.n
		variance = (sum_x_sqr/n) - ((sum_x/n)*(sum_x/n))
		this
	}
}
val r = scala.util.Random
val doubleRDD = sc.parallelize(for (i <- 1 to 100) yield r.nextInt(100).toDouble)

var result = doubleRDD.mapPartitions(v => Iterator(new RunningVar(v))).reduce((a, b) => a.merge(b))

assert(result.variance === doubleRDD.variance() +- .001)

println(result.variance)
println(doubleRDD.variance)
