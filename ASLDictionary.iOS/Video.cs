using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using SQLite;

namespace ASLDictionary.iOS
{
	[Table("Video")]
	class Video
	{
		//The vocabulary word as displayed, also the primary key for the database.
		[PrimaryKey]
		public string VocabWord { get; set; }

		//url path to video to be played
		public string URL { get; set; }

		//the unit within the class that the video belongs to
		public string Unit { get; set; }

		//the class that the unit is in (0101 or 0102)
		public string Class { get; set; }

		//string representation of an entire data row
		public override string ToString()
		{
			return string.Format("[Video: Word={0}, URL={1}, Unit = {2}, Class = {3}]", VocabWord, URL, Unit, Class);
		}
	}
}
