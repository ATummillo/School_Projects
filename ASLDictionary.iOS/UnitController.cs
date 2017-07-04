using Foundation;
using System.Collections.Generic;
using System;
using UIKit;
using System.IO;
using SQLite;
using System.Linq;

namespace ASLDictionary.iOS
{
	public partial class UnitController : UITableViewController
	{
		private List<string> words;
        private List<string> filteredWords;
        private UISearchBar searchBar;
        private UnitControllerDataSource wordSource;
        static NSString unitControllerID = new NSString("WordCell");

		public UnitController(IntPtr handle) : base(handle)
		{
			TableView.RegisterClassForCellReuse(typeof(UITableViewCell), unitControllerID);
            wordSource = new UnitControllerDataSource(this);
            TableView.Source = wordSource;
		}

		public void setWords(List<string> s)
		{
			this.words = s;
            this.filteredWords = s;
		}

		public void setTitle(string s)
		{
			this.NavigationItem.Title = s;
		}

        public override void ViewDidLoad(){
            base.ViewDidLoad();

			searchBar = new UISearchBar();
			searchBar.SizeToFit();
			searchBar.AutocorrectionType = UITextAutocorrectionType.No;
			searchBar.AutocapitalizationType = UITextAutocapitalizationType.None;
			searchBar.TextChanged += (sender, e) =>
			{
				//this is the method that is called when the user searches
				Search();
			};
            TableView.TableHeaderView = searchBar;
        }

		private void Search()
		{
            //perform the search, and refresh the table with the results
            wordSource.PerformSearch(searchBar.Text);
            TableView.ReloadData();
		}

		class UnitControllerDataSource : UITableViewSource
		{
			UnitController controller;
			string dbPath = Path.Combine(
					Environment.GetFolderPath(Environment.SpecialFolder.Personal),
					"db_video.db");

			public UnitControllerDataSource(UnitController controller)
			{
				this.controller = controller;
			}

			public override nint RowsInSection(UITableView tableview, nint section)
			{
				return new nint(controller.filteredWords.Count);
			}

			public override UITableViewCell GetCell(UITableView tableView, NSIndexPath indexPath)
			{
				var cell = tableView.DequeueReusableCell(UnitController.unitControllerID);

				int row = indexPath.Row;
				cell.TextLabel.Text = controller.filteredWords[row];
				return cell;
			}

			private Video getVideoFromDB(string name)
			{
				var db = new SQLiteConnection(dbPath);
				return db.Get<Video>(name);
			}

			public override void RowSelected(UITableView tableView, NSIndexPath indexPath)
			{
				//Action performed when a cell is selected
				var sb = UIStoryboard.FromName("Main", null);
                var vid = getVideoFromDB(controller.words[indexPath.Row]);
                VideoController selectedVideo = sb.InstantiateViewController("VideoController") as VideoController;
                selectedVideo.setUrl(vid.URL);
                selectedVideo.setTitle(controller.words[indexPath.Row]);
                controller.NavigationController.PushViewController(selectedVideo, true);
			}

			public void PerformSearch(string searchText)
			{
				//filter master data set by the text entered by the user
				searchText = searchText.ToLower();
                controller.filteredWords = controller.words.Where(x => x.ToLower().Contains(searchText)).ToList();
			}
		}
	}
}