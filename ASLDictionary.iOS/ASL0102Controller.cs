using Foundation;
using System.Collections.Generic;
using System;
using UIKit;
using System.IO;
using SQLite;

namespace ASLDictionary.iOS
{
	public partial class ASL0102Controller : UITableViewController
	{
		private String[] class2_units;
		static NSString classTwoId = new NSString("ASL0102UnitCell");

		public ASL0102Controller(IntPtr handle) : base(handle)
		{
			TableView.RegisterClassForCellReuse(typeof(UITableViewCell), classTwoId);
			TableView.Source = new ASL0102DataSource(this);
		}

		public override void ViewWillAppear(Boolean animated)
		{
			NavigationController.SetNavigationBarHidden(false, true);
		}

		public void setUnits(String[] s)
		{
			class2_units = s;
		}


		class ASL0102DataSource : UITableViewSource
		{
			ASL0102Controller controller;

			public ASL0102DataSource(ASL0102Controller controller)
			{
				this.controller = controller;
			}

			public override nint RowsInSection(UITableView tableview, nint section)
			{
				return new nint(controller.class2_units.Length);
			}

			public override UITableViewCell GetCell(UITableView tableView, NSIndexPath indexPath)
			{
				var cell = tableView.DequeueReusableCell(ASL0102Controller.classTwoId);

				int row = indexPath.Row;
				cell.TextLabel.Text = controller.class2_units[row];
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
					videoNames = getVideoNames(7, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 7");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 1)
				{
					videoNames = getVideoNames(8, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 8");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 2)
				{
					videoNames = getVideoNames(9, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 9");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 3)
				{
					videoNames = getVideoNames(10, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 10");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
				else if (indexPath.Row == 4)
				{
					videoNames = getVideoNames(11, dbPath);
					selectedUnit.setWords(videoNames);
					selectedUnit.setTitle("Unit 11");
					controller.NavigationController.PushViewController(selectedUnit, true);
				}
			}

			private List<string> getVideoNames(int unit, string path)
			{
				List<string> names = new List<string>();
				var db = new SQLiteConnection(path);
				string query = "SELECT * FROM Video WHERE Class = 2 AND Unit = ?";

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