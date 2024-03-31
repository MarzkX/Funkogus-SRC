
using System.IO;
using System.Windows.Forms;

namespace FlixelCrashHandler
{
    partial class FlixelCrashHandler
    {
        /// <summary>
        /// Variável de designer necessária.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpar os recursos que estão sendo usados.
        /// </summary>
        /// <param name="disposing">true se for necessário descartar os recursos gerenciados; caso contrário, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código gerado pelo Windows Form Designer

        /// <summary>
        /// Método necessário para suporte ao Designer - não modifique 
        /// o conteúdo deste método com o editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.background = new System.Windows.Forms.PictureBox();
            this.infoLabel = new System.Windows.Forms.Label();
            this.reportThisText = new System.Windows.Forms.Label();
            this.Exitbutton = new System.Windows.Forms.Button();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            ((System.ComponentModel.ISupportInitialize)(this.background)).BeginInit();
            this.SuspendLayout();
            // 
            // background
            // 
            this.background.BackColor = System.Drawing.Color.Transparent;
            this.background.ImageLocation = "M:\\Crash-Handler-for-haxeflixel-1.0.0\\solution\\bin\\Debug\\crashlogs\\assets\\bg.png";
            this.background.Location = new System.Drawing.Point(0, 0);
            this.background.Name = "background";
            this.background.Size = new System.Drawing.Size(600, 575);
            this.background.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.background.TabIndex = 0;
            this.background.TabStop = false;
            // 
            // infoLabel
            // 
            this.infoLabel.BackColor = System.Drawing.Color.Black;
            this.infoLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.infoLabel.ForeColor = System.Drawing.Color.White;
            this.infoLabel.Location = new System.Drawing.Point(25, 125);
            this.infoLabel.Name = "infoLabel";
            this.infoLabel.Size = new System.Drawing.Size(491, 253);
            this.infoLabel.TabIndex = 1;
            this.infoLabel.Text = "label1";
            // 
            // reportThisText
            // 
            this.reportThisText.BackColor = System.Drawing.Color.Black;
            this.reportThisText.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.reportThisText.ForeColor = System.Drawing.Color.White;
            this.reportThisText.Location = new System.Drawing.Point(20, 387);
            this.reportThisText.Name = "reportThisText";
            this.reportThisText.Size = new System.Drawing.Size(491, 86);
            this.reportThisText.TabIndex = 2;
            this.reportThisText.Text = "If your game keeps crashing with the same error, report it to our github. A \"MM-D" +
    "D-YYYY-log.txt\" file has been created.";
            // 
            // Exitbutton
            // 
            this.Exitbutton.BackColor = System.Drawing.Color.Transparent;
            this.Exitbutton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Exitbutton.Location = new System.Drawing.Point(25, 476);
            this.Exitbutton.Name = "Exitbutton";
            this.Exitbutton.Size = new System.Drawing.Size(177, 73);
            this.Exitbutton.TabIndex = 4;
            this.Exitbutton.Text = "button1";
            this.Exitbutton.UseVisualStyleBackColor = false;
            this.Exitbutton.Click += new System.EventHandler(this.Exitbutton_Click);
            // 
            // FlixelCrashHandler
            //
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.Exitbutton;
            this.ClientSize = new System.Drawing.Size(550, 575);
            this.Controls.Add(this.Exitbutton);
            this.Controls.Add(this.reportThisText);
            this.Controls.Add(this.infoLabel);
            this.Controls.Add(this.background);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Game Crashed!";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Game Crashed!";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.background)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.PictureBox background;
        public System.Windows.Forms.Label infoLabel;
        public System.Windows.Forms.Label reportThisText;
        private System.Windows.Forms.Button Exitbutton;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
    }
}

