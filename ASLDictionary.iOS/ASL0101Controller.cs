using Foundation;
using System.Collections.Generic;
using System;
using UIKit;
using System.IO;
using SQLite;

namespace ASLDictionary.iOS
{
	public partial class ASL0101Controller : UITableViewController
	{
		private string[] class1_units;
		static NSString classOneId = new NSString("ASL0101UnitCell");

		public ASL0101Controller(IntPtr handle) : base(handle)
		{
			TableView.RegisterClassForCellReuse(typeof(UITableViewCell), classOneId);
			TableView.Source = new ASL0101DataSource(this);
		}

		public override void ViewWillAppear(Boolean animated)
		{
			NavigationController.SetNavigationBarHidden(false, true);
		}

		public void setUnits(String[] s)
		{
			class1_units = s;
		}

		//TableViewSource subclass to populate table view with units 
		class ASL0101DataSource : UITableViewSource
		{
			ASL0101Controller controller;

			public ASL0101DataSource(ASL0101Controller controller)
			{
				this.controller = controller;
			}

			public override nint RowsInSection(UITableView tableview, nint section)
			{
				return new nint(controller.class1_units.Length);
			}

			public override UITableViewCell GetCell(UITableView tableView, NSIndexPath indexPath)
			{
				var cell = tableView.DequeueReusableCell(ASL0101Controller.classOneId);

				int row = indexPath.Row;
				cell.TextLabel.Text = controller.class1_units[row];
				return cell;
			}

			public override void RowSelected(UITableView tableView, NSIndexPath indexPath)
			{
				//Action performed when a cell is selected
				var sb = UIStoryboard.FromName("Main", null);
				List<string> videoNames = new List<string>();
				string dbPath = Path.Combine(
					Environment.GetFolderPath(Environment.SpecialFolder.Personal),
					"db_video.db");
				UnitController selectedUnit = sb.InstantiateViewController("UnitController") as UnitController;

				if (indexPath.Row == 0)
				{
					videoNames = getVideoNames(1, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 1");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 1)
				{
					videoNames = getVideoNames(2, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 2");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 2)
				{
					videoNames = getVideoNames(3, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 3");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 3)
				{
					videoNames = getVideoNames(4, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 4");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 4)
				{
					videoNames = getVideoNames(5, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 5");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 5)
				{
					videoNames = getVideoNames(6, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 6");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
			}

			private List<string> getVideoNames(int unit, string path)
			{
				List<string> names = new List<string>();
				var db = new SQLiteConnection(path);
				string query = "SELECT * FROM Video WHERE Class = 1 AND Unit = ?";

				List<Video> videos = db.Query<Video>(query, unit);
				foreach (var video in videos)
				{
					names.Add(video.VocabWord);
				}
				return names;
			}
		}
	}
}