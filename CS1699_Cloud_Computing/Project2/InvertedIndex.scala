package com.examples

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.log4j.Logger

object InvertedIndex {

  def main(arg: Array[String]) {

    var logger = Logger.getLogger(this.getClass())

    if (arg.length < 2) {
      logger.error("=> wrong parameters number")
      System.err.println("Usage: MainExample <path-to-files> <output-path>")
      System.exit(1)
    }

    val jobName = "InvertedIndex"

    val conf = new SparkConf().setAppName(jobName)
    val sc = new SparkContext(conf)

    val pathToFiles = arg(0)
    val outputPath = arg(1)

    logger.info("=> jobName \"" + jobName + "\"")
    logger.info("=> pathToFiles \"" + pathToFiles + "\"")

    val files = sc.wholeTextFiles(pathToFiles)

    val InvIndex = files.flatMap{
      case (path, text) =>
        var title = path.split("/").last
        text.replaceAll("[^\\w\\s]", " ").toLowerCase().split("""\W+""").map{
          word => (word, title)
        }
    }.map{
      case (word, path) => ((word,path),1)
    }.reduceByKey {
      (x,y) => (x+y)
    }.map{
      case ((word, title), count) => (word, (title, count))
    }.groupBy{
      case (word, (title, count)) => word
    }.map{
      case (word, list) =>
        var list2 = list.map{
          case (_, (title, count)) => (title, count)
        }
        (word, list2.mkString(", "))
    }
    // and save the result
    InvIndex.saveAsTextFile(outputPath)

  }
}
