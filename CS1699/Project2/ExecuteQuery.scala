package com.examples

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.log4j.Logger

object ExecuteQuery {

  def main(arg: Array[String]) {

    var logger = Logger.getLogger(this.getClass())

    if (arg.length != 3) {
      logger.error("=> wrong parameters number")
      System.err.println("Usage: MainExample <path-to-files> <output-path> <query>")
      System.err.println(arg(2))
      System.exit(1)
    }

    val jobName = "ExecQuery"

    val conf = new SparkConf().setAppName(jobName)
    val sc = new SparkContext(conf)

    val pathToFiles = arg(0)
    val outputPath = arg(1)
    val query = arg(2).split("\\s+")

    logger.info("=> jobName \"" + jobName + "\"")
    logger.info("=> pathToFiles \"" + pathToFiles + "\"")

    val files = sc.textFile(pathToFiles)

    val ExecQuery = files.map{
      case (text) =>
        if(query.contains(text.split(",")(0).drop(1))){
          text
        }else{
          ""
        }
    }.filter{
      x => x.length > 0
    }

    ExecQuery.saveAsTextFile(outputPath)
  }
}