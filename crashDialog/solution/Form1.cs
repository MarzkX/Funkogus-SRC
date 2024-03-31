using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing.Text;
using System.IO;
using System.Diagnostics;

namespace FlixelCrashHandler
{
    public partial class FlixelCrashHandler : Form
    {
        private string[] crashInfo;
        string appPath = Directory.GetCurrentDirectory();
        public FlixelCrashHandler(string[] args)
        {
            crashInfo = args;
            InitializeComponent();
        }
        public struct LoadedFont
        {
            public Font Font { get; set; }
            public FontFamily FontFamily { get; set; }
        }

        /**
        ** THIS IS FOR LOADING CUSTOM FONTS
        **/
        public static LoadedFont LoadFont(string file, int fontSize, FontStyle fontStyle)
        {
            var fontCollection = new PrivateFontCollection();
            fontCollection.AddFontFile(file);
            if (fontCollection.Families.Length < 0)
            {
                throw new InvalidOperationException("No font familiy found when loading font");
            }

            var loadedFont = new LoadedFont();
            loadedFont.FontFamily = fontCollection.Families[0];
            loadedFont.Font = new Font(loadedFont.FontFamily, fontSize, fontStyle, GraphicsUnit.Pixel);
            return loadedFont;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string info = "To prevent leaving you in total confusion, heres some information we've gathered:" + "\n \n" + crashInfo[0];
            if (!File.Exists(appPath+"/crashlogs"))
            {
                Directory.CreateDirectory(appPath+"/crashlogs");
                Console.WriteLine("crashlogs folder not found, creating");
            }
            else
            {
                Console.WriteLine("crashlogs folder found!!!");
            }

            DateTime localTime = DateTime.Now;

            string dateNTime = localTime.Year.ToString() + '/' + localTime.Month.ToString()
            + '/' + localTime.Day.ToString() + ' ' + localTime.Hour.ToString() 
            + ':' + localTime.Minute.ToString() + ':' + localTime.Second.ToString();
            string dateNTimeValid = dateNTime;
            dateNTimeValid = dateNTimeValid.Replace("/", "-");
            dateNTimeValid = dateNTimeValid.Replace(" ", "_");
            dateNTimeValid = dateNTimeValid.Replace(":", "'");

            string logName = "Funkogus_" + dateNTimeValid + ".txt";
            string reportInfo = "If your game keeps crashing with the same error, report it to our github. A " + logName + " file has been created.";
            Font PhantomMuff = LoadFont(appPath+"/crashlogs/assets/vcr.ttf", 16, FontStyle.Regular).Font;
            Font PhantomMuffBig = LoadFont(appPath + "/crashlogs/assets/vcr.ttf", 24, FontStyle.Regular).Font;

            background.ImageLocation = appPath + "/crashlogs/assets/bg.png";

            infoLabel.Parent = background;
            infoLabel.BackColor = Color.Transparent;
            infoLabel.Text = info;
            infoLabel.ForeColor = Color.White;
            infoLabel.Font = PhantomMuff;

            reportThisText.Font = PhantomMuff;
            reportThisText.Text = reportInfo;
            reportThisText.Parent = background;
            reportThisText.BackColor = Color.Transparent;
            reportThisText.ForeColor = Color.White;

            Exitbutton.Text = "Exit";
            Exitbutton.Font = PhantomMuffBig;
            Exitbutton.Parent = background;
            Exitbutton.BackColor = Color.Transparent;
            Exitbutton.ForeColor = Color.White;
            Exitbutton.FlatAppearance.MouseDownBackColor = Color.Transparent;
            Exitbutton.FlatAppearance.MouseOverBackColor = Color.Transparent;
        }

        private void Exitbutton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
