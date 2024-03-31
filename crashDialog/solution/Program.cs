using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Text;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Security;
using System.Security.Permissions;
using System.Reflection;
using System.Diagnostics;

namespace FlixelCrashHandler
{
    static class Program
    {
        static void SetDefaultIcon()
        {
            var icon = Icon.ExtractAssociatedIcon(EntryAssemblyInfo.ExecutablePath);
            typeof(Form)
            .GetField("defaultIcon", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static)
            .SetValue(null, icon);
        }

        /// <summary>
        /// Ponto de entrada principal para o aplicativo.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            if (System.Diagnostics.Debugger.IsAttached)
            {
                args = new string[] { "FLIXELCRASHHANDLER RUNNING IN DEBUG MODE" };
                Console.WriteLine("Running in debug mode");
            }
            if (args.Length < 1)
            {
                Application.Exit();
                return;
            }
            //args = new string[] {"sdasdfsdf s tth \n fsudhfhwthfyh hahahhaha"};
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            SetDefaultIcon();
            Application.Run(new FlixelCrashHandler(args));
        }
    }

    static class EntryAssemblyInfo
    {
        private static string _executablePath;
        public static string ExecutablePath
        {
            get
            {
                if (_executablePath == null)
                {
                PermissionSet permissionSets = new PermissionSet(PermissionState.None);
                permissionSets.AddPermission(new FileIOPermission(PermissionState.Unrestricted));
                permissionSets.AddPermission(new SecurityPermission(SecurityPermissionFlag.UnmanagedCode));
                permissionSets.Assert();

                string uriString = null;
                var entryAssembly = Assembly.GetEntryAssembly();

                if (entryAssembly == null)
                    uriString = Process.GetCurrentProcess().MainModule.FileName;
                else
                    uriString = entryAssembly.CodeBase;

                PermissionSet.RevertAssert();

                if (string.IsNullOrWhiteSpace(uriString))
                    throw new Exception("Can not Get EntryAssembly or Process MainModule FileName");
                else
                {
                    var uri = new Uri(uriString);
                    if (uri.IsFile)
                        _executablePath = string.Concat(uri.LocalPath, Uri.UnescapeDataString(uri.Fragment));
                    else
                        _executablePath = uri.ToString();
                }
            }

            return _executablePath;
        }
    }
}
}
