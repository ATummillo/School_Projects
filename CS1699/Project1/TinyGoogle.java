import java.io.IOException;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FileUtil;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.io.Text;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;

public class TinyGoogle {
	private static String working_directory = System.getProperty("user.dir");
	private static Runtime rt = Runtime.getRuntime();
	private static Configuration config;
	private static FileSystem hdfs;
	private static Path homeDirectory;
	private static Path books;
	private static Path output;
	private static Path queryOutput;
	private static Scanner scan;

	public static void main(String args[]) throws IOException, IllegalArgumentException, ClassNotFoundException, InterruptedException {
		Path temp_in = new Path("/books");
		Path temp_out = new Path("/InvertedIndexOutput_MR");
		Path temp_out2 = new Path("/InvertedIndexOutput_MR_query");
		config = new Configuration();
		hdfs = FileSystem.get(config);
		homeDirectory = hdfs.getHomeDirectory();
		books = Path.mergePaths(homeDirectory, temp_in);
		output = Path.mergePaths(homeDirectory, temp_out);
		queryOutput = Path.mergePaths(homeDirectory, temp_out2);
		scan = new Scanner(System.in);

		HashMap<String, Long> sizes;
		
		System.out.println("Welcome to TinyGoogle, Map_Reduce edition!\n");
		
		if(checkForBooks()){
			deleteBooks();
		}
		
		if(checkForOutputDir()){
			deleteOutput();
		}

		createBooksAndIndex();
		mergeOutput(1);
		sizes = getSizes();
		
		while(true){
			String action = getAction();
			switch(action){
			case "1":
				if(checkForQueryOutputDir()){
					deleteQueryOutput();
				}
				System.out.println("Please enter your query terms (seperated by spaces)");
				String query = scan.nextLine();
				executeQuery(query, sizes);
				break;
			case "2":
				deleteBooks();
				deleteOutput();
				createBooksAndIndex();
				mergeOutput(1);
				sizes = getSizes();
				break;
			case "3":
				exitEngine();
			}
		}
	}

	private static boolean checkForBooks() throws IOException {
		return hdfs.exists(books);
	}
	
	private static boolean checkForOutputDir() throws IOException{
		return hdfs.exists(output);
	}
	
	private static boolean checkForQueryOutputDir() throws IOException{
		return hdfs.exists(queryOutput);
	}

	private static boolean deleteBooks() throws IOException {
		return hdfs.delete(books, true);
	}
	
	private static boolean deleteOutput() throws IOException{
		return hdfs.delete(output, true);
	}
	
	private static boolean deleteQueryOutput() throws IOException{
		return hdfs.delete(queryOutput, true);
	}

	private static void createBooksAndIndex() {
		System.out.println("Please enter the full (local) path of the directory containing "
				+ "the books you would like to index");
		
		while (true) {
			try {
				Path localSrc = new Path(scan.nextLine());
				hdfs.copyFromLocalFile(localSrc, books);
				break;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				System.out.println("Sorry your local path doesn't appear to be valid\n");
				System.out.println("Hint: Use your terminal to navigate to the directory which contains the folder"
						+ " where your books are stored.\nNext enter the command 'pwd' to find the correct full path.");
				System.out.println("Please try to enter the correct full (local) path again."); 
			}
		}
		
		if(index()){
			System.out.println("Indexing completed Successfully!");
		}else{
			System.out.println("Indexing could not be completed Successfully :(");
		}
	}
	
	private static boolean index(){
		Configuration conf = new Configuration();

		try {
			Job job = Job.getInstance(conf);
			job.setJarByClass(InvertedIndex.class);
			job.setJobName("Inverted Index");
			FileInputFormat.addInputPath(job, books);
			FileOutputFormat.setOutputPath(job, output);
			job.setMapperClass(InvertedIndexMapper.class);
			job.setReducerClass(InvertedIndexReducer.class);
			job.setOutputKeyClass(Text.class);
			job.setOutputValueClass(Text.class);
			return job.waitForCompletion(true);
			
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("IO error when trying to run indexing job!");
			return false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.out.println("ClassNotFound error when trying to run indexing job!");
			return false;
		} catch (InterruptedException e) {
			e.printStackTrace();
			System.out.println("Interrupted error when trying to run indexing job!");
			return false;
		}
	}
	
	private static String getContext(String item, String book) throws IllegalArgumentException, IOException{
		FSDataInputStream fsStream = hdfs.open(Path.mergePaths(books, new Path("/" + book)));
		BufferedReader reader = new BufferedReader(new InputStreamReader(fsStream));
		
		String prevLine = "";
		String currLine = reader.readLine();
		String result;
		
		while(!Arrays.asList(currLine.toLowerCase().split("\\b+")).contains(item.toLowerCase())){
			prevLine = currLine;
			currLine = reader.readLine();
		}
		
		result = "\t\"" + prevLine + "\n\t" + currLine + "\n\t" + reader.readLine() + "\"";
		reader.close();
		
		return result;
	}
	
	private static void mergeOutput(int opt) throws IllegalArgumentException, IOException{
		
		if(opt == 1){
			hdfs.delete(Path.mergePaths(output, new Path("/_SUCCESS")), true);
			FileUtil.copyMerge(hdfs, output, hdfs, Path.mergePaths(output, new Path("/index")), false, config, null);
		}else if(opt == 2){
			hdfs.delete(Path.mergePaths(queryOutput, new Path("/_SUCCESS")), true);
			FileUtil.copyMerge(hdfs, queryOutput, hdfs, Path.mergePaths(queryOutput, new Path("/index")), false, config, null);
		}else{
			System.out.println("Error in opt passed to mergeOutput.");
		}
	}
	
	public static String getAction(){
		System.out.println("What would you like to do?");
		System.out.println("\t1. Submit a query");
		System.out.println("\t2. Submit a new directory of books to be indexed");
		System.out.println("\t3. Exit the search engine");
		System.out.println("(your input must be a number inbetween 1-3, no other input will be accepted)");
		String input;
		
		while(true){
			input = scan.nextLine();
			if(input.equals("1") || input.equals("2") || input.equals("3")){
				break;
			}else{
				System.out.println("That is not a valid input, try again! (must be a number from 1-3)");
			}
		}
		return input;
	}
	
	public static HashMap<String, Long> getSizes() throws FileNotFoundException, IOException{
		HashMap<String, Long> sizes = new HashMap<String, Long>();
		FileStatus[] stat = hdfs.listStatus(books);
		
		for(int i = 0; i<stat.length; i++){
			String path = stat[i].getPath().toString();
			String[] arr = path.split("/");
			sizes.put(arr[arr.length-1], stat[i].getLen());
		}
		
		return sizes;
	}
//	/Users/anthonytummillo/Desktop/CS1699/books
	public static void executeQuery(String query, HashMap<String, Long> sizes) throws IllegalArgumentException, IOException, ClassNotFoundException, InterruptedException{
		String[] terms = query.split("\\s+");
		int numTotalDocs = sizes.size();
		
		Configuration conf = new Configuration();
		conf.setStrings("query", terms);
		
		Job job = Job.getInstance(conf);
		job.setJarByClass(ExecuteQuery.class);
		job.setJobName("Execture Query");
		FileInputFormat.addInputPath(job, Path.mergePaths(output, new Path ("/index")));
		FileOutputFormat.setOutputPath(job, queryOutput);
		job.setMapperClass(QueryMapper.class);
		job.setReducerClass(QueryReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		job.waitForCompletion(true);
		
		mergeOutput(2);
		
		FSDataInputStream fsStream = hdfs.open(Path.mergePaths(queryOutput, new Path("/index")));
		BufferedReader reader = new BufferedReader(new InputStreamReader(fsStream));
		String line = reader.readLine();
				
		HashMap<String, HashMap<String, Double>> indexMap = new HashMap<String, HashMap<String, Double>>();
		HashMap<String, Double> termMap;
		String[] lineArray;
		String[] temp;
		
		while(line != null){
			lineArray = line.split("#");
			termMap = new HashMap<String, Double>();
			
			for(int i = 1; i<lineArray.length; i++){
				temp = lineArray[i].split(",");
				
				termMap.put(temp[0], calcTFIDF(Long.parseLong(temp[1]), sizes.get(temp[0]), numTotalDocs, lineArray.length-1));
			}	
			indexMap.put(lineArray[0].replaceAll("\\s+", ""), termMap);
			line = reader.readLine();
		}
		
		//Will hold  DocName -> map(term -> total weight)
		HashMap<String, tuple> finalDocs = new HashMap<String, tuple>();
		//Will hold DocName -> list(map(term -> weight))
		HashMap<String, ArrayList<tuple>> docWeightList = new HashMap<String, ArrayList<tuple>>();
		
		for(Map.Entry<String, HashMap<String,Double>> entry : indexMap.entrySet()){
			//query term
			String term = entry.getKey();
			//docName -> tfidf for query term
			HashMap<String,Double> termScores = entry.getValue();
			for(Map.Entry<String, Double> docMap : termScores.entrySet()){
				String tmpDocName = docMap.getKey();
				double tmpWeight = docMap.getValue();
				if(docWeightList.get(tmpDocName) == null){
					docWeightList.put(tmpDocName, new ArrayList<tuple>());
				}
				tuple dwlEntry = new tuple(term, tmpWeight);
				docWeightList.get(tmpDocName).add(dwlEntry);
			}
		}
		
		/* docWeightList is functioning so now the weights must be totaled keeping track of the most important term */
		for(Map.Entry<String, ArrayList<tuple>> dwlEntry : docWeightList.entrySet()){
			String impTerm = "";
			double maxWeight = 0;
			double totalWeight = 0;
			String docName = dwlEntry.getKey();
			ArrayList<tuple> weightList = dwlEntry.getValue();
			
			for(tuple termTuple : weightList){
				double tmpWeight = termTuple.getWeight();
				if(tmpWeight > maxWeight){
					maxWeight = tmpWeight;
					impTerm = termTuple.getTerm();
				}
				totalWeight += tmpWeight;
			}
			
			finalDocs.put(docName, new tuple(impTerm, totalWeight));
		}
		
		printTopFive(finalDocs);
	}
	
	public static void printTopFive(HashMap<String, tuple> docMap) throws IllegalArgumentException, IOException{
		Set<Map.Entry<String, tuple>> entries = docMap.entrySet();
		
		Comparator<Map.Entry<String, tuple>> valueComparator = new Comparator<Map.Entry<String, tuple>>() { 
			@Override 
			public int compare(Map.Entry<String, tuple> e1, Map.Entry<String, tuple> e2) { 
				tuple t1 = e1.getValue(); 
				tuple t2 = e2.getValue(); 
				return t1.compareTo(t2); 
			} 
		};
		
		ArrayList<Map.Entry<String, tuple>> listOfEntries = new ArrayList<Map.Entry<String, tuple>>(entries);
		Collections.sort(listOfEntries, Collections.reverseOrder(valueComparator));
		System.out.println("\n\n\n");
		
		if(listOfEntries.size() >= 5){
			for(int i = 0; i<5; i++){
				String title = listOfEntries.get(i).getKey();
				String item = listOfEntries.get(i).getValue().getTerm();
				System.out.println("Result Rank #" + (i+1) + ": " + title);
				System.out.println(getContext(item, title) + "\n");
			}
		
			System.out.println("\n\n\n####################-END OF QUERY-####################");
		}else{
			for(int i = 0; i<listOfEntries.size(); i++){
				String title = listOfEntries.get(i).getKey();
				String item = listOfEntries.get(i).getValue().getTerm();
				System.out.println("Result Rank #" + (i+1) + ": " + title);
				System.out.println(getContext(item, title) + "\n");
			}
		
			System.out.println("\n\n\n####################-END OF QUERY-####################");
		}
	}
	
	public static double calcTFIDF(double frequency, double size, int numTotalDocs, int docsPerTerm){
		double score = 0;
		double tf = frequency/size;
		double idf = Math.log10((double)numTotalDocs/(double)docsPerTerm);
		score = tf*idf;
		return score;
	}
	
	public static void exitEngine() throws IOException{
		deleteBooks();
		deleteOutput();
		deleteQueryOutput();
		System.out.println("The books and output directories on your DFS have been deleted and the search engine is exiting."
				+ "\nHave a great day!");
		System.exit(0);
	}
	
	//Tuple class to help with data organization while querying 
	private static class tuple implements Comparator<tuple>, Comparable<tuple>{
		private String term;
		private Double weight;
		
		tuple(String s, Double w){
			this.term = s;
			this.weight = w;
		}
		
		public String getTerm(){
			return term;
		}
		
		public double getWeight(){
			return weight;
		}
		
		public void setTerm(String s){
			this.term = s;
		}
		
		public void setWeight(Double d){
			this.weight = d;
		}
		
		public String toString(){
			return "(term/doc:" + this.term + ", " + "weight:" + this.weight + ")";
		}
		
		public int compareTo(tuple t){
			return (this.weight).compareTo(t.weight);
		}
		
		public int compare(tuple t1, tuple t2){
			return (int) (t1.weight - t2.weight);
		}
	}
}