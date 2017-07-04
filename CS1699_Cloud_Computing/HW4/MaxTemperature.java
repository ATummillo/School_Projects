// cc MaxTemperature Application to find the maximum temperature in the weather dataset
// vv MaxTemperature
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;


public class MaxTemperature {
	private static final String OUTPUT_PATH = "java_intermediate";

	public static void main(String[] args) throws Exception {
		if (args.length != 2) {
			System.err.println("Usage: MaxTemperature <input path> <output path>");
			System.exit(-1);
		}

		//First Job
		Job job1 = new Job();
		job1.setJarByClass(MaxTemperature.class);
		job1.setJobName("Max temperature1");

		FileInputFormat.addInputPath(job1, new Path(args[0]));
		FileOutputFormat.setOutputPath(job1, new Path(OUTPUT_PATH));

		job1.setMapperClass(MaxTemperatureMapper1.class);
		job1.setReducerClass(MaxTemperatureReducer1.class);

		job1.setOutputKeyClass(Text.class);
		job1.setOutputValueClass(IntWritable.class);

		job1.waitForCompletion(true);

		//Second Job
		Job job2 = new Job();
		job2.setJarByClass(MaxTemperature.class);
		job2.setJobName("Max temperature2");

		FileInputFormat.addInputPath(job2, new Path(OUTPUT_PATH));
		FileOutputFormat.setOutputPath(job2, new Path(args[1]));

		job2.setMapperClass(MaxTemperatureMapper2.class);
		job2.setReducerClass(MaxTemperatureReducer2.class);

		job2.setOutputKeyClass(Text.class);
		job2.setOutputValueClass(IntWritable.class);

		System.exit(job2.waitForCompletion(true) ? 0 : 1);
	}
// ^^ MaxTemperature

	public static class MaxTemperatureMapper1
		extends Mapper<LongWritable, Text, Text, IntWritable> {

		private static final int MISSING = 9999;

		@Override
		public void map(LongWritable key, Text value, Context context)
		throws IOException, InterruptedException {

			String line = value.toString();
			String station_date = line.substring(4, 23);
			//String year = line.substring(15, 19);
			int airTemperature;
			if (line.charAt(87) == '+') { // parseInt doesn't like leading plus signs
				airTemperature = Integer.parseInt(line.substring(88, 92));
			} else {
				airTemperature = Integer.parseInt(line.substring(87, 92));
			}
			String quality = line.substring(92, 93);
			if (airTemperature != MISSING && quality.matches("[01459]")) {
				context.write(new Text(station_date), new IntWritable(airTemperature));
			}
		}
	}
// ^^ MaxTemperatureMapper1

	public static class MaxTemperatureReducer1
		extends Reducer<Text, IntWritable, Text, IntWritable> {

		@Override
		public void reduce(Text key, Iterable<IntWritable> values,
		                   Context context)
		throws IOException, InterruptedException {

			int maxValue = Integer.MIN_VALUE;
			for (IntWritable value : values) {
				maxValue = Math.max(maxValue, value.get());
			}
			context.write(key, new IntWritable(maxValue));
		}
	}
// ^^ MaxTemperatureReducer1

	public static class MaxTemperatureMapper2
		extends Mapper<LongWritable, Text, Text, IntWritable> {

		@Override
		public void map(LongWritable key, Text value, Context context)
		throws IOException, InterruptedException {

			String[] line_array = value.toString().split("\t");
			String station = line_array[0].substring(0, 11);
			String date_month_day = line_array[0].substring(15);
			String station_date_md = station + date_month_day;
			int temp = Integer.parseInt(line_array[1]);
			
			context.write(new Text(station_date_md), new IntWritable(temp));
		}
	}
// ^^ MaxTemperatureMapper2

	public static class MaxTemperatureReducer2
		extends Reducer<Text, IntWritable, Text, IntWritable> {

		@Override
		public void reduce(Text key, Iterable<IntWritable> values,
		                   Context context)
		throws IOException, InterruptedException {

			int sum = 0;
			int count = 0;
			for (IntWritable value : values) {
				sum += value.get();
				count++;
			}
			int mean = sum/count;
			context.write(key, new IntWritable(mean));
		}
	}
// ^^ MaxTemperatureReducer2
}