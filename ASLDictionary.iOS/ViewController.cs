using System;
using System.Collections.Generic;
using UIKit;
using System.IO;
using SQLite;

namespace ASLDictionary.iOS
{
	public partial class ViewController : UIViewController
	{
		private string[] class1_units = { "UNIT 1", "UNIT 2", "UNIT 3", "UNIT 4", "UNIT 5", "UNIT 6" };
		private string[] class2_units = { "UNIT 7", "UNIT 8", "UNIT 9", "UNIT 10", "UNIT 11" };


		public ViewController(IntPtr handle) : base(handle)
		{

		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();
			//Configures buttons and button controllers
			ClassOneButton.BackgroundColor = UIColor.White;
			ClassTwoButton.BackgroundColor = UIColor.White;

			ClassOneButton.TouchUpInside += (object sender, EventArgs e) =>
			{
				//Actions taken when ASL0101 button is hit
				ASL0101Controller classOne = this.Storyboard.InstantiateViewController("ASL0101Controller") as ASL0101Controller;
				//Console.WriteLine("Click boi");

				if (classOne != null)
				{
					classOne.setUnits(class1_units);
					this.NavigationController.PushViewController(classOne, true);
				}
			};

			ClassTwoButton.TouchUpInside += (object sender, EventArgs e) =>
			{
				//Actions taken when ASL0102 button is hit
				ASL0102Controller classTwo = this.Storyboard.InstantiateViewController("ASL0102Controller") as ASL0102Controller;

				if (classTwo != null)
				{
					classTwo.setUnits(class2_units);
					this.NavigationController.PushViewController(classTwo, true);
				}
			};


			//Handles the database
			string dbPath = Path.Combine(
					Environment.GetFolderPath(Environment.SpecialFolder.Personal),
					"db_video.db");

			if (!File.Exists(dbPath))
			{
				string result = createDatabase(dbPath);
				if (result.Equals("Database created"))
				{
					Console.WriteLine("DB created successfully");

					//Disable buttons until database is populated
					ClassOneButton.Enabled = false;
					ClassTwoButton.Enabled = false;

					var alert = UIAlertController.Create("Sorry for the wait!", "Because this is the first time this application has been opened, "
						+ "the video database will need to be configured. This may take a few seconds, " +
						"just bear with us and be patient please! Thank you :)", UIAlertControllerStyle.Alert);
					alert.AddAction(UIAlertAction.Create("I understand", UIAlertActionStyle.Default, alertMethod => populateDatabase(dbPath)));
					PresentViewController(alert, true, null);
				}
				else
				{
					Console.WriteLine("DB not created successfully");
				}
			}
			else
			{
				Console.WriteLine("DB already created");
			}
		}

		public override void ViewWillAppear(Boolean animated)
		{
			NavigationController.SetNavigationBarHidden(true, true);
		}

		public override void DidReceiveMemoryWarning()
		{
			base.DidReceiveMemoryWarning();
			// Release any cached data, images, etc that aren't in use.
		}

		private string createDatabase(string path)
		{
			try
			{

				var connection = new SQLiteConnection(path);
				connection.CreateTable<Video>();
				return "Database created";
			}
			catch (SQLiteException ex)
			{
				return ex.Message;
			}
		}

		private string insertUpdateVideo(Video vid, string path)
		{
			try
			{
				var db = new SQLiteConnection(path);
				if (db.Update(vid) == 0)
					db.Insert(vid);
				return "Single video inserted or updated";
			}
			catch (SQLiteException e)
			{
				return e.Message;
			}
		}

		private void populateDatabase(string path)
		{
			string line;
			StreamReader sr;

			try
			{
				sr = new StreamReader(System.IO.File.Open("Video_Assets/video_init.txt", System.IO.FileMode.Open, FileAccess.Read));
				while ((line = sr.ReadLine()) != null)
				{
					string[] lineSplit = line.Split(',');
					Video newVideo = new Video();
					newVideo.VocabWord = lineSplit[0].ToLower();
					newVideo.URL = lineSplit[1];
					newVideo.Unit = lineSplit[2];
					newVideo.Class = lineSplit[3];
					insertUpdateVideo(newVideo, path);
				}

				var alert = UIAlertController.Create("Databse configuration is complete!", "Thank you for waiting! You may now use the application!", UIAlertControllerStyle.Alert);
				alert.AddAction(UIAlertAction.Create("Enjoy", UIAlertActionStyle.Default, null));
				PresentViewController(alert, true, null);

				ClassOneButton.Enabled = true;
				ClassTwoButton.Enabled = true;
			}
			catch (FileNotFoundException ex)
			{
				Console.WriteLine("video_init.txt could not be found");
			}
		}
	}
}
