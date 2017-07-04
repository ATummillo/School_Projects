def toIntFriends(x: String): (Int, Array[Int]) = {
	var string_arr = x.split(" ")
	var int_arr = new Array[Int](string_arr.length) 
	int_arr(0) = string_arr(0).dropRight(1).toInt //Get rid of comma next to first number
	
	for (i <- 1 to (string_arr.length - 1)) {
        int_arr(i) = string_arr(i).toInt;
    }
	return (int_arr(0),int_arr.slice(1,int_arr.length)) 
}

def toKeyVal(x: (Int, Array[Int])): Array[((Int, Int), Array[Int])] = {
	var output_arr = new Array[((Int, Int), Array[Int])](x._2.length);

	for (i <- 0 to (x._2.length - 1)) {
		if(x._1 < x._2(i)){
			output_arr(i) = ((x._1, x._2(i)), x._2)
		}else{
			output_arr(i) = ((x._2(i), x._1), x._2)
		}
	}

	return output_arr
}

val textFile = sc.textFile("hdfs://localhost:9000/user/anthonytummillo/spark_dir/friends.txt")
val common_friends = textFile.map(toIntFriends(_)).flatMap(toKeyVal(_)).reduceByKey((x,y) => x.intersect(y)) //returns Array[Array[Int]]
val common_friends_final = common_friends.sortByKey().collect()

println("\n")

for (i <- 0 to (common_friends_final.length - 1)) {
	println(common_friends_final(i)._1 + " " + common_friends_final(i)._2.mkString(" "))
}
