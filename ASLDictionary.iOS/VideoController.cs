using AVKit;
using AVFoundation;
using Foundation;
using System;

namespace ASLDictionary.iOS
{
    public partial class VideoController : AVPlayerViewController
    {
        private string URL = "";
        AVPlayer player;

        public VideoController (IntPtr handle) : base (handle)
        {
            
        }

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
			player = new AVPlayer(NSUrl.FromString(URL));
            this.Player = player;
			player.Play();
        }

		public void setUrl(String s)
		{
			this.URL = s;
		}

		public void setTitle(string s)
		{
			this.NavigationItem.Title = s;
		}
    }
}