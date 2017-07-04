import java.io.IOException;

import java.util.*;
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
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class QueryMapper
	extends Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
	throws IOException, InterruptedException {

		Collection<String> query = context.getConfiguration().getStringCollection("query");
		String line = value.toString();
		String[] termDocs = line.split("\t");
		String term = termDocs[0].toLowerCase();
		if(query.contains(term)){
			String[] nameArray = termDocs[1].replaceAll("[={},1-9]", "").split("\\s+");
			String[] countArray = termDocs[1].replaceAll("[={},A-Za-z.]", "").split("\\s+");

			for(int i= 0; i<nameArray.length; i++){
				context.write(new Text(term), new Text("#" + nameArray[i] + "," + countArray[i]));
			}
		}else{
			//do nothing
		}
	}
}