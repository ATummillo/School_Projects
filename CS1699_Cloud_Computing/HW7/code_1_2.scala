val r = scala.util.Random
val params1 = sc.parallelize(1 to 100).map(x => (x, r.nextInt(100)))
params1.cache()
params1.collect().foreach(println)
val params2 = params1.map(item => item.swap).sortByKey(false,1).map(item => item.swap)
params2.cache()
params2.take(10).foreach(println)



