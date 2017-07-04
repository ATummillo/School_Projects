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

public class InvertedIndexReducer
	extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values,
	                   Context context)
	throws IOException, InterruptedException {

		HashMap map = new HashMap();
		int count = 0;

		for(Text t: values){
			String s = t.toString();

			if(map != null && map.get(s) != null){
				count = (int) map.get(s);
				count++;
				map.put(s, count);
			}else{
				map.put(s, 1);
			}
		}

		context.write(key, new Text(map.toString()));
	}
}